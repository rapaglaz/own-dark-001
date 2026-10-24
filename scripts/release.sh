#!/usr/bin/env bash
#
# Makes a release in two steps, because main accepts changes only through pull requests:
#
#   prepare [vX.Y.Z]  on an up-to-date main: sets the version in package.json, prepends the
#                     changes to CHANGELOG.md with git-cliff on the branch chore/release-vX.Y.Z,
#                     commits it, pushes the branch and opens a pull request. Without a version,
#                     git-cliff computes it (cliff.toml, [bump]).
#   tag               on main after that pull request is merged: creates the signed tag vX.Y.Z
#                     on the release commit and pushes it. The Release workflow then packages
#                     the extension, creates the GitHub Release and publishes to the Marketplace.
#
# Usage: bash scripts/release.sh prepare [vX.Y.Z] | tag
#        (or `mise run release:prepare [vX.Y.Z]` and `mise run release:tag`)

set -euo pipefail

# An empty CDPATH keeps cd from searching it and printing the directory.
CDPATH='' cd -- "$(dirname "${BASH_SOURCE[0]}")/.."

fail() {
    echo "$1" >&2
    exit 1
}

# Both steps start from main without local changes and at the same commit as origin/main.
require_current_main() {
    [[ "$(git branch --show-current)" == main ]] || fail "Run this on main."
    [[ -z "$(git status --porcelain)" ]] || fail "The working tree has changes; commit or stash them first."
    git fetch --quiet --tags origin
    [[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/main)" ]] ||
        fail "main differs from origin/main; run git pull --ff-only first."
}

require_new_tag() { # <version>
    [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "Expected a version like v0.1.0, got: $1"
    if git rev-parse -q --verify "refs/tags/$1" >/dev/null; then
        fail "The tag $1 exists already."
    fi
}

package_version() {
    node -p 'require("./package.json").version'
}

prepare() { # [version]
    require_current_main
    local version="${1:-$(git cliff --bumped-version 2>/dev/null)}"
    # git-cliff returns the latest tag when no commit since then raises the version.
    if [[ -z "${1:-}" && "$version" == "$(git describe --tags --abbrev=0)" ]]; then
        fail "No releasable commits since $version."
    fi
    require_new_tag "$version"
    local branch="chore/release-$version"

    git switch --quiet -c "$branch"
    pnpm version "${version#v}" --no-git-tag-version --no-git-checks >/dev/null
    # Prepend only, because the entries before 0.3.0 were removed on purpose and must not come back.
    git cliff --unreleased --tag "$version" --prepend CHANGELOG.md 2>/dev/null
    git add CHANGELOG.md package.json
    git commit -S -m "chore(release): $version"
    git push --quiet -u origin "$branch"
    gh pr create --base main --head "$branch" --title "chore(release): $version" \
        --body "This PR sets the version to $version and adds its changes to CHANGELOG.md. After the merge, run \`mise run release:tag\` on main."

    echo "Merge the pull request after CI is green, then run on main:"
    echo "  git switch main && git pull --ff-only && mise run release:tag"
}

tag() {
    require_current_main
    # A squash merge adds the number of the pull request to the subject.
    local subject pattern='^chore\(release\): (v[0-9]+\.[0-9]+\.[0-9]+)( \(#[0-9]+\))?$'
    subject="$(git log -1 --format=%s)"
    [[ "$subject" =~ $pattern ]] ||
        fail "The last commit on main is not a release commit: $subject"
    local version="${BASH_REMATCH[1]}"
    require_new_tag "$version"
    [[ "v$(package_version)" == "$version" ]] ||
        fail "package.json has version $(package_version), but the release commit is $version."

    git tag -s "$version" -m "$version"
    git push --quiet origin "$version"
    echo "Pushed the signed tag $version; the Release workflow creates the GitHub Release and publishes the extension."
}

case "${1:-}" in
    prepare) prepare "${2:-}" ;;
    tag) tag ;;
    *) fail "Usage: bash scripts/release.sh prepare [vX.Y.Z] | tag" ;;
esac

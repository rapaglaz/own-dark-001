# Contributing

Tools and tasks are managed with [mise](https://mise.jdx.dev). The versions are pinned in `mise.toml`, so that CI and your terminal use the same toolchain.

## Setup

```sh
mise install
mise run install
```

## Tasks

| Task                         | Description                         |
| ---------------------------- | ----------------------------------- |
| `mise run pack`              | Build the `.vsix` package           |
| `mise run format:check`      | Check formatting with Prettier      |
| `mise run format:write`      | Format files with Prettier          |
| `mise run changelog:preview` | Print the notes of the next release |

`mise tasks ls` lists all tasks.

## Release

A release has two steps, because `main` accepts changes only through pull requests.

Requirements:

- A GPG key for signed commits and tags (`git commit -S`, `git tag -s`).
- The GitHub CLI with a login (`gh auth login`).

Steps:

```sh
mise run release:prepare   # on main: release branch, version, CHANGELOG.md, pull request
# merge the pull request, then:
git switch main && git pull --ff-only
mise run release:tag       # signed tag; the Release workflow packages and publishes
```

git-cliff computes the next version from the commits. To set the version by hand, pass it as an argument:

```sh
mise run release:prepare v0.4.0
```

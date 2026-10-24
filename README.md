# Own Dark 001

A calm dark theme built for daily work.
Cool blue-grey UI, pastel syntax highlighting, low visual noise.

## Install

[VS Code Marketplace →](https://marketplace.visualstudio.com/items?itemName=own-themes.own-dark-001)

## Screenshots

### TypeScript

![TypeScript](https://github.com/rapaglaz/own-dark-001/blob/main/screenshots/screenshot-70.png?raw=true)

### HTML

![HTML](https://github.com/rapaglaz/own-dark-001/blob/main/screenshots/screenshot-71.png?raw=true)

### CSS

![CSS](https://github.com/rapaglaz/own-dark-001/blob/main/screenshots/screenshot-72.png?raw=true)

### JSON

![JSON](https://github.com/rapaglaz/own-dark-001/blob/main/screenshots/screenshot-73.png?raw=true)

### YAML

![YAML](https://github.com/rapaglaz/own-dark-001/blob/main/screenshots/screenshot-74.png?raw=true)

## Development

Tools and tasks are managed with [mise](https://mise.jdx.dev).

```sh
mise install
mise run install
mise run pack
```

`mise run changelog:preview` prints the notes of the next release.

A release has two steps, because `main` accepts changes only through pull requests:

```sh
mise run release:prepare   # on main: release branch, version, CHANGELOG.md, pull request
# merge the pull request, then:
git switch main && git pull --ff-only
mise run release:tag       # signed tag; the Release workflow packages and publishes
```

# action-wails3-linux-windows

Fast, cached GitHub Composite Action to build **Wails v3** applications for **Linux** (`.deb`, `.rpm`, `.AppImage`) and **Windows** (`amd64` / `arm64` `.exe` and NSIS installers) on Ubuntu runners.

## Speed Optimizations

- **APT `.deb` cache**: Caches downloaded Linux/cross-build `.deb` packages (`libgtk-4-dev`, `libwebkitgtk-6.0-dev`, `nsis`, `rpm`, etc.) and installs with `--no-install-recommends`.
- **Wails v3 CLI cache**: Caches the compiled `wails3` binary instead of compiling it from Go source on every run.
- **Go & Frontend caches**: Uses `actions/setup-go@v5` Go build/module cache and caches `npm`/`pnpm`/`yarn`/`bun` caches with `--prefer-offline`.

## Usage

```yaml
jobs:
  build-linux-windows:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - uses: tss182/action-wails3-linux-windows@v1
        with:
          app-name: dhub
          version: "0.3.7"
          pre-build-command: make update-asset
```

## Inputs

| Input | Default | Description |
| --- | --- | --- |
| `working-directory` | `.` | Project root directory |
| `frontend-dir` | `frontend` | Frontend directory relative to `working-directory` |
| `app-name` | `''` | App name (auto-detected from `Taskfile.yml` if omitted) |
| `version` | `''` | Release version (updates `build/config.yml` and creates versioned filenames) |
| `go-version-file` | `go.mod` | Path to `go.mod` |
| `go-version` | `''` | Explicit Go version (overrides `go-version-file`) |
| `node-version` | `20` | Node.js version |
| `package-manager` | `npm` | `npm`, `pnpm`, `yarn`, or `bun` |
| `wails-version` | `v3.0.0` | Wails v3 CLI version |
| `skip-apt` | `false` | Skip `apt-get` dependency installation |
| `pre-build-command` | `''` | Command to run before building (e.g. `make update-asset`) |
| `build-command` | `''` | Custom build command replacing default Wails tasks |
| `build-linux-deb` | `true` | Build `.deb` package |
| `build-linux-rpm` | `true` | Build `.rpm` package |
| `build-linux-appimage` | `false` | Build `.AppImage` |
| `build-windows-amd64` | `true` | Build Windows amd64 `.exe` |
| `build-windows-amd64-installer` | `true` | Build Windows amd64 NSIS installer |
| `build-windows-arm64` | `true` | Build Windows arm64 `.exe` |
| `build-windows-arm64-installer` | `true` | Build Windows arm64 NSIS installer |
| `windows-install-scope` | `user` | NSIS `INSTALL_SCOPE` (`user` or `machine`) |

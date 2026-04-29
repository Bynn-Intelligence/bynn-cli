# bynn

Command-line interface for the [BYNN Intelligence](https://bynn.com) API — identity verification, age verification, AutoDoc, document fraud analysis, NFC, content moderation, and face collections.

The CLI is **auto-discovering**: every command is built at runtime from the live OpenAPI spec at `https://api.bynn.com/openapi.json`. New endpoints in the API surface in the CLI on the next invocation, with no re-install.

## Install

### macOS and Linux (Homebrew)

```bash
brew install bynn-intelligence/bynn/bynn
```

### Windows (Scoop)

```powershell
scoop bucket add bynn https://github.com/Bynn-Intelligence/scoop-bynn
scoop install bynn
```

### Linux (.deb / .rpm)

Grab the package matching your architecture from the [latest release](https://github.com/Bynn-Intelligence/bynn-cli/releases/latest), e.g.:

```bash
# Debian / Ubuntu (amd64)
curl -LO https://github.com/Bynn-Intelligence/bynn-cli/releases/latest/download/bynn_$(uname -m).deb
sudo apt install ./bynn_*.deb

# RHEL / Fedora (amd64)
sudo rpm -i https://github.com/Bynn-Intelligence/bynn-cli/releases/latest/download/bynn_*.rpm
```

### One-line installer (any unix)

```bash
curl -fsSL https://raw.githubusercontent.com/Bynn-Intelligence/bynn-cli/main/install.sh | sh
```

The installer detects your OS and architecture, downloads the matching binary from the latest release, and places it at `/usr/local/bin/bynn` (or `~/.local/bin/bynn` if you can't write to `/usr/local/bin`).

### Manual download

Pre-built binaries for every supported platform live in [Releases](https://github.com/Bynn-Intelligence/bynn-cli/releases/latest). Download, extract, and place `bynn` somewhere on your `PATH`.

## Quick start

```bash
# 1. Authenticate (your private key is stored in the OS keychain)
bynn auth login

# 2. Verify
bynn auth whoami

# 3. Use any endpoint exposed by the API
bynn submit ./passport.pdf --reference case-123
bynn sessions create --body '{"reference":"abc"}'
bynn moderation models-all
```

Run `bynn --help` to see every available command. Add `--help` to any subcommand for detailed flags and examples (sourced from the live OpenAPI spec).

## Profiles

Run against multiple environments without juggling tokens:

```bash
bynn config use sandbox            # switch active profile
bynn auth login --profile sandbox  # store a sandbox key
bynn config list                   # see all profiles
```

Test vs. live mode is encoded in the API key prefix (`private_sandbox_...` vs. `private_...`); no separate flag needed.

## Output formats

```bash
bynn moderation models-all -o json
bynn moderation models-all -o yaml
bynn moderation models-all --jq '.[].api_name'
```

## Updating

```bash
brew upgrade bynn       # macOS / Linux via Homebrew
scoop update bynn       # Windows via Scoop
# or re-run the install.sh one-liner — it always fetches the latest release
```

## Support

- Documentation: [docs.bynn.com](https://docs.bynn.com)
- Dashboard: [dashboard.bynn.com](https://dashboard.bynn.com)
- Email: [hello@bynn.com](mailto:hello@bynn.com)

## License

Proprietary. © BYNN Intelligence, Inc.

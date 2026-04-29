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
# profile=live mode=live base_url=https://api.bynn.com/v1
```

### Submit a PDF for fraud and risk analysis

```bash
# Send a document for analysis — supports jpg, jpeg, png, pdf
bynn submit ./invoice.pdf --reference case-1234
```

Output (default table; add `-o json` for raw JSON):

```
┌───────────────┬───────────────────────────────────┐
│     FIELD     │               VALUE               │
├───────────────┼───────────────────────────────────┤
│ document_id   │ XD4PXZJ9E                         │
│ jwt           │                                   │
│ status        │ received                          │
│ submission_id │ document_XpAzvcXkQYtXUPipmiWMVnGP │
└───────────────┴───────────────────────────────────┘
```

Note the `document_id` — analysis runs asynchronously, then the result is retrievable via:

```bash
# Fetch the analysis result (poll once analysis completes — usually seconds)
bynn documents get XD4PXZJ9E -o json
```

Useful flags on `submit`:

```bash
# attach metadata that travels with the submission
bynn submit ./id.jpg --reference case-1234 \
    --document-type passport \
    --side front \
    --issuing-country USA \
    --tenant-id acme \
    --case-id INC-42

# preview the JSON body that would be sent (file content redacted) without actually submitting
bynn submit ./id.jpg --reference case-1234 --dry-run -o json

# scriptable: extract just the document_id for a follow-up `documents get`
DOC_ID=$(bynn submit ./id.jpg --reference case-1234 -o json --jq '.document_id')
bynn documents get "$DOC_ID" -o json
```

### Other common operations

```bash
# Identity verification sessions
bynn sessions create --body '{"reference":"verify-abc"}'
bynn sessions get <session_id>

# AutoDoc invitations
bynn autodoc invitations-list --all
bynn autodoc invitations-create --body '{"...":"..."}'

# Content moderation model catalog (no auth needed)
bynn moderation models-all
```

Run `bynn --help` to see every command. Append `--help` to any subcommand for detailed flags and examples (sourced from the live OpenAPI spec, so they always reflect the current API).

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

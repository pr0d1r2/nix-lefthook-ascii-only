# nix-lefthook-ascii-only

[![CI](https://github.com/pr0d1r2/nix-lefthook-ascii-only/actions/workflows/ci.yml/badge.svg)](https://github.com/pr0d1r2/nix-lefthook-ascii-only/actions/workflows/ci.yml)

> This code is LLM-generated and validated through an automated integration process using [lefthook](https://github.com/evilmartians/lefthook) git hooks, [bats](https://github.com/bats-core/bats-core) unit tests, and GitHub Actions CI.

Lefthook-compatible [ASCII-only](https://en.wikipedia.org/wiki/ASCII) file checker, packaged as a Nix flake.

Checks staged files for non-ASCII characters. Exits 0 when no matching files are found.

## Usage

### Option A: Lefthook remote (recommended)

Add to your `lefthook.yml` - no flake input needed, just the wrapper binary in your devShell:

```yaml
remotes:
  - git_url: https://github.com/pr0d1r2/nix-lefthook-ascii-only
    ref: main
    configs:
      - lefthook-remote.yml
```

### Option B: Flake input

Add as a flake input:

```nix
inputs.nix-lefthook-ascii-only = {
  url = "github:pr0d1r2/nix-lefthook-ascii-only";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Add to your devShell:

```nix
nix-lefthook-ascii-only.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Add to `lefthook.yml`:

```yaml
pre-commit:
  commands:
    ascii-only:
      run: timeout ${LEFTHOOK_ASCII_ONLY_TIMEOUT:-30} lefthook-ascii-only {staged_files}
```

### Configuring timeout

The default timeout is 30 seconds. Override per-repo via environment variable:

```bash
export LEFTHOOK_ASCII_ONLY_TIMEOUT=60
```

## Development

The repo includes an `.envrc` for [direnv](https://direnv.net/) - entering the directory automatically loads the devShell with all dependencies:

```bash
cd nix-lefthook-ascii-only  # direnv loads the flake
bats tests/unit/
```

If not using direnv, enter the shell manually:

```bash
nix develop
bats tests/unit/
```

## License

MIT

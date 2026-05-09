# shellcheck shell=bash
# Lefthook-compatible ASCII-only file checker.
# Detects non-ASCII characters in staged files.
# Usage: lefthook-ascii-only file1 [file2 ...]
# NOTE: sourced by writeShellApplication - no shebang or set needed.

if [ $# -eq 0 ]; then
    exit 0
fi

exit_code=0
for file in "$@"; do
    [ -f "$file" ] || continue
    matches=$(LC_ALL=C grep -Pn '[^\x00-\x7F]' "$file" 2>/dev/null || true)
    if [ -n "$matches" ]; then
        echo "Non-ASCII in $file:"
        echo "$matches"
        exit_code=1
    fi
done
exit "$exit_code"

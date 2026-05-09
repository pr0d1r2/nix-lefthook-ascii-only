#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    TMP="$BATS_TEST_TMPDIR"
}

@test "no args exits 0" {
    run lefthook-ascii-only
    assert_success
}

@test "non-existent file is skipped" {
    run lefthook-ascii-only /nonexistent/file.txt
    assert_success
}

@test "clean ASCII file passes" {
    echo "hello world" > "$TMP/clean.txt"
    run lefthook-ascii-only "$TMP/clean.txt"
    assert_success
}

@test "file with non-ASCII characters fails" {
    printf 'hello w\xc3\xb6rld\n' > "$TMP/nonascii.txt"
    run lefthook-ascii-only "$TMP/nonascii.txt"
    assert_failure
    assert_output --partial "Non-ASCII"
}

@test "multiple files: one bad fails the run" {
    echo "clean" > "$TMP/good.txt"
    printf 'caf\xc3\xa9\n' > "$TMP/bad.txt"
    run lefthook-ascii-only "$TMP/good.txt" "$TMP/bad.txt"
    assert_failure
}

@test "empty file passes" {
    touch "$TMP/empty.txt"
    run lefthook-ascii-only "$TMP/empty.txt"
    assert_success
}

#! /usr/bin/env bash
set -e

# Run this from the VSCode prompt in Remote mode to have `code` command
# work in other terminals of the same host.

function find_code() {
    which -a code | grep /.vscode-server/bin/ | head -1
}

CODE_BIN=$(find_code)

[[ -n $VSCODE_IPC_HOOK_CLI ]] || ($CODE_BIN ; exit 2)

echo "VSCODE_IPC_HOOK_CLI=$VSCODE_IPC_HOOK_CLI $CODE_BIN" '$*' > ~/bin/code
chmod +x ~/bin/code

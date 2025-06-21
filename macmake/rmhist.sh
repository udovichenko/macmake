#!/bin/bash

# This script removes a specified command from the Zsh history file.

# Check if a command to remove was provided as an argument.
if [[ -z "$1" ]]; then
  echo "Error: No command specified."
  echo "Usage: make rmhist c=\"<exact command to delete>\" [dry_run=true]"
  exit 1
fi

COMMAND_TO_REMOVE="$1"
DRY_RUN_FLAG="$2"
HISTORY_FILE=~/.zsh_history

# Verify that the Zsh history file exists.
if [ ! -f "$HISTORY_FILE" ]; then
    echo "Error: Zsh history file not found at $HISTORY_FILE"
    exit 1
fi

# Escape special characters in the command to prevent issues with sed.
# This handles characters like '/', '&', and '' which have special meaning in sed.
ESCAPED_COMMAND=$(printf '%s\n' "$COMMAND_TO_REMOVE" | LC_ALL=C sed -e 's/[&/\\]/\\&/g')

# Check if zsh_history has extended history format
if LC_ALL=C grep -q "^: [0-9]\{10\}:[0-9]\{1,\};" "$HISTORY_FILE"; then
    # The Zsh history format with EXTENDED_HISTORY is: `: <timestamp>:<duration>;<command>`
    GREP_PATTERN="^: [0-9]{10}:[0-9]+;${ESCAPED_COMMAND}$"
    SED_DELETE_CMD="/^: [0-9]\\{10\\}:[0-9]\\{1,\\};${ESCAPED_COMMAND}$/d"
else
    # The history file does not seem to use EXTENDED_HISTORY format.
    # Assume one command per line.
    GREP_PATTERN="^${ESCAPED_COMMAND}$"
    SED_DELETE_CMD="/^${ESCAPED_COMMAND}$/d"
fi

if [[ "$DRY_RUN_FLAG" == "--dry-run" ]]; then
    # Use grep -q to check for matches without printing them.
    if LC_ALL=C grep -q -E "$GREP_PATTERN" "$HISTORY_FILE"; then
        echo "Dry run: Found the following matches for '$COMMAND_TO_REMOVE' in your Zsh history:"
        LC_ALL=C grep -E --color=always "$GREP_PATTERN" "$HISTORY_FILE"
    else
        echo "Dry run: No matches found for '$COMMAND_TO_REMOVE' in your Zsh history."
    fi
else
    # The following sed command finds lines matching this format with the specified command and deletes them.
    # It operates directly on the history file and creates a backup with a .bak extension.
    LC_ALL=C sed -i.bak "$SED_DELETE_CMD" "$HISTORY_FILE"

    echo "Attempted to remove all instances of '$COMMAND_TO_REMOVE' from your Zsh history."
    echo "A backup of your original history has been saved to ${HISTORY_FILE}.bak"
    echo "To see the changes in your current terminal session, please run: fc -R"
fi

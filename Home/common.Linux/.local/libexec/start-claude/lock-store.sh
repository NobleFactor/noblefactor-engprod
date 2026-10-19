# shellcheck shell=bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Noble Factor. All rights reserved.

# lock-store.sh - Linux's lock on Start-Claude's store
#
# Start-Claude and Sync-ClaudeSession source this file, which only Linux deploys, from ~/.local/libexec/start-claude
# (David-Noble-at-work/personal#259, requirement 17 of its plan).

require_command flock

# take_store_lock locks Start-Claude's store on descriptor 9, which the caller holds open on the lock file, waiting up
# to 10 seconds while another holds it.
#
# Linux ships util-linux's flock, and the kernel releases its lock when the descriptor closes.
#
# Parameters:
#   - none.
#
# Returns:
#   - 0 when the lock is taken; non-zero when another holds it for 10 seconds.
function take_store_lock {
    flock --wait 10 9
}

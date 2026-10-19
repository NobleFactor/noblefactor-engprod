# shellcheck shell=bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Noble Factor. All rights reserved.

# lock-store.sh - macOS's lock on Start-Claude's store
#
# Start-Claude and Sync-ClaudeSession source this file, which only macOS deploys, from ~/.local/libexec/start-claude
# (David-Noble-at-work/personal#259, requirement 17 of its plan).

# take_store_lock locks Start-Claude's store on descriptor 9, which the caller holds open on the lock file, waiting up
# to 10 seconds while another holds it.
#
# Darwin locks with lockf and never flock: macOS does not ship flock, and one that is installed is not used (question
# 65). lockf's descriptor form locks inside a script, as Linux's flock does, and the kernel releases the lock when the
# descriptor closes. lockf is called by its full path, so no other lockf on PATH stands in for it.
#
# Parameters:
#   - none.
#
# Returns:
#   - 0 when the lock is taken; non-zero when another holds it for 10 seconds.
function take_store_lock {
    /usr/bin/lockf -s -t 10 9
}

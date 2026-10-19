# shellcheck shell=bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Noble Factor. All rights reserved.

# keychain.sh - Linux's login keychain, for Start-Claude
#
# Start-Claude sources this file, which only Linux deploys, from ~/.local/libexec/start-claude
# (David-Noble-at-work/personal#277, requirement 19 of its plan). Linux has no keychain to unlock for it: claude keeps
# its login in ~/.claude/.credentials.json, and gh's keyring answers an ssh session, as both did on danoble-ud24-1 on
# 2026-10-13.

# login_keychain_is_locked reports whether this session finds the login keychain locked, which on Linux it never does.
#
# Parameters:
#   - none.
#
# Returns:
#   - 1.
function login_keychain_is_locked {
    return 1
}

# unlock_login_keychain has nothing to unlock on Linux.
#
# Parameters:
#   - none.
#
# Returns:
#   - 0.
function unlock_login_keychain {
    return 0
}

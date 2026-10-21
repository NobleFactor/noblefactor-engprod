# shellcheck shell=bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

# keychain.sh - macOS's login keychain, for Start-Claude
#
# Start-Claude sources this file, which only macOS deploys, from ~/.local/libexec/agent-schedule
# (David-Noble-at-work/personal#277, requirement 19 of its plan). gh and claude keep their logins in the login keychain,
# which an ssh session finds locked until it is unlocked there.

# login_keychain_is_locked reports whether this session finds the login keychain locked: security cannot read the
# keychain's settings without its password, as .zprofile tests it.
#
# security is called by its full path, so no other security on PATH stands in for it.
#
# Parameters:
#   - none.
#
# Returns:
#   - 0 when it is locked; 1 when it is open.
function login_keychain_is_locked {
    ! /usr/bin/security show-keychain-info login.keychain-db >/dev/null 2>&1
}

# unlock_login_keychain unlocks the login keychain for this session, asking for its password on the terminal.
#
# Parameters:
#   - none.
#
# Returns:
#   - 0 when it is unlocked; security's status when it is not.
function unlock_login_keychain {
    /usr/bin/security unlock-keychain login.keychain-db </dev/tty
}

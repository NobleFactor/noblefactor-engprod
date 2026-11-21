#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.
#
# credentials-check.sh - prove the token this repository's workflows sign in with, and keep its incidents (#613)
#
# The credentials check's logic, which credentials-check.yml runs daily in each participating repository. It proves the
# token through the same secret the repository's workflows read, and raises one incident per condition in this
# repository, assigned to the owner, with the run's own GITHUB_TOKEN, so that it never depends on the token it checks.
# An open incident gets a comment each day its condition holds, and closes when a check shows the condition gone.
#
# An organization's token is a GitHub App: the check signs a JSON Web Token with the key, finds the app's installation
# on the account, mints an installation token, and requires the permissions GitHub grants it to include every one
# credentials-check.json names. A user account's is a classic token: the check calls GitHub with it, and requires its
# login to be the account, its scopes to include every one the file names, and its expiry to be beyond the margin. An
# app key isn't expired but rotated, due on TOKEN_ROTATION_DUE. GitHub not reached is no credential condition: the run
# fails, the next one checks again, and no incident is raised (#621).
#
# Environment:
#   KIND                organization or user.
#   ACCOUNT, REPOSITORY the account and this repository, owner/name.
#   GH_TOKEN            the run's GITHUB_TOKEN, with issues: write, for the incidents.
#   APP_ID, APP_PRIVATE_KEY  an organization's app, from its secrets.
#   PAT                 a user account's classic token, from its secret.
#   ROTATION_DUE        an organization's next key rotation, YYYY-MM-DD, from TOKEN_ROTATION_DUE; optional.
#   WATCH               repositories whose latest check this run also watches, comma-separated; optional.
#   MODE                check, the default, or report: raise consumer-failed with DETAIL, and change nothing else.
#   DETAIL              what failed, in report mode.
#   RUN_URL             this run's page, named in every incident.
#   CONFIG              credentials-check.json; default: beside this script.
#   GITHUB_API_URL      GitHub's API; default: https://api.github.com.
#
# Exit status: 0 when every condition is clear, 1 when one holds, 2 when GitHub couldn't be reached.
set -uo pipefail

: "${KIND:?}" "${ACCOUNT:?}" "${REPOSITORY:?}" "${GH_TOKEN:?}"
config="${CONFIG:-$(dirname -- "$0")/credentials-check.json}"
api="${GITHUB_API_URL:-https://api.github.com}"
mode="${MODE:-check}"
run="${RUN_URL:-the run}"
margin="$(jq -r .margin_days "${config}")"
assignee="$(jq -r .assignee "${config}")"
guide="$(jq -r .guide "${config}")"
label=token-alert
work="$(mktemp -d)"
trap 'rm -rf -- "${work}"' EXIT

declare -A found=()
declare -a watched=()

# raise records a condition that holds, with what was seen.
raise() {
    found["$1"]="$2"
}

# epoch prints the UTC midnight of a date's day, YYYY-MM-DD first, in seconds; GNU or BSD date.
epoch() {
    local day="${1:0:10}"
    date -u -d "${day}" +%s 2>/dev/null || date -u -j -f "%Y-%m-%d %H:%M:%S" "${day} 00:00:00" +%s
}

# days_until prints the whole days from today to a date, negative once it has passed.
days_until() {
    local due now
    due="$(epoch "$1")" || return 1
    now="$(epoch "$(date -u +%Y-%m-%d)")" || return 1
    printf '%d\n' $(((due - now) / 86400))
}

# call makes one request of GitHub, the body to ${work}/body and the headers to ${work}/headers, and prints the HTTP
# status. A request that doesn't reach GitHub returns 2, and its caller exits 2 at once: no credential is at fault
# (#621). It returns rather than exits, since it runs in a command substitution, whose exit would end only that.
call() {
    local code
    if ! code="$(curl -sS --max-time 30 -o "${work}/body" -D "${work}/headers" -w '%{http_code}' "$@" \
        2>"${work}/curl")"; then
        printf 'GitHub not reached: %s; no credential is at fault, and the next run checks again\n' \
            "$(<"${work}/curl")" >&2
        return 2
    fi
    printf '%s\n' "${code}"
}

# header prints a response header's value, matched without regard to case.
header() {
    tr -d '\r' <"${work}/headers" | awk -v h="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" -F': ' \
        'tolower($1) == h { $1 = ""; sub(/^ /, ""); print; exit }'
}

# b64url prints its input as unpadded base64url, as a JSON Web Token takes it.
b64url() {
    openssl base64 -A | tr '+/' '-_' | tr -d '='
}

# check_app proves an organization's app: its key signs, it is installed on the account, and the installation token
# GitHub mints holds every permission credentials-check.json names.
check_app() {
    if [[ -z "${APP_ID:-}" || -z "${APP_PRIVATE_KEY:-}" ]]; then
        local names="NOBLEFACTOR_AUTOMATION_APP_ID and NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY"
        raise missing "the organization secrets ${names} aren't both set"
        return
    fi
    local key="${work}/key.pem" now head body signature jwt code installation needed short
    (umask 077 && printf '%s\n' "${APP_PRIVATE_KEY}" >"${key}")
    now="$(date -u +%s)"
    head="$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)"
    body="$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' $((now - 60)) $((now + 540)) "${APP_ID}" | b64url)"
    if ! signature="$(printf '%s.%s' "${head}" "${body}" | openssl dgst -sha256 -sign "${key}" 2>/dev/null | b64url)" ||
        [[ -z "${signature}" ]]; then
        raise refused "the private key in NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY can't sign a token"
        return
    fi
    jwt="${head}.${body}.${signature}"
    code="$(call -H "Authorization: Bearer ${jwt}" -H "Accept: application/vnd.github+json" \
        "${api}/app/installations")" || exit 2
    if [[ "${code}" != 200 ]]; then
        raise refused "GitHub refused app ${APP_ID}'s key: HTTP ${code}"
        return
    fi
    installation="$(jq -r --arg a "${ACCOUNT}" \
        '.[] | select((.account.login | ascii_downcase) == ($a | ascii_downcase)) | .id' "${work}/body" | head -n 1)"
    if [[ -z "${installation}" ]]; then
        raise not-installed "app ${APP_ID} isn't installed on ${ACCOUNT}"
        return
    fi
    code="$(call -X POST -H "Authorization: Bearer ${jwt}" -H "Accept: application/vnd.github+json" \
        "${api}/app/installations/${installation}/access_tokens")" || exit 2
    if [[ "${code}" != 201 ]]; then
        raise refused "GitHub minted no installation token for app ${APP_ID}: HTTP ${code}"
        return
    fi
    needed="$(jq -c .organization.permissions "${config}")"
    short="$(jq -r --argjson need "${needed}" '
        def rank: {"read": 1, "write": 2, "admin": 3}[.] // 0;
        .permissions as $got | $need | to_entries[] | select(($got[.key] // "" | rank) < (.value | rank))
        | "\(.key): \(.value), granted \($got[.key] // "none")"' "${work}/body" | paste -sd ';' -)"
    if [[ -n "${short}" ]]; then
        raise short "the installation token lacks ${short}"
    fi
}

# check_rotation warns before an app key's rotation date, and after it.
check_rotation() {
    [[ -n "${ROTATION_DUE:-}" ]] || return 0
    local left
    left="$(days_until "${ROTATION_DUE}")" || {
        raise rotation-due "TOKEN_ROTATION_DUE, ${ROTATION_DUE}, isn't a date"
        return
    }
    if ((left < 0)); then
        raise rotation-overdue "the app key's rotation was due on ${ROTATION_DUE:0:10}"
    elif ((left <= margin)); then
        raise rotation-due "the app key's rotation is due on ${ROTATION_DUE:0:10}, in ${left} days"
    fi
}

# check_token proves a user account's classic token: it signs in as the account, with every scope, before its expiry.
check_token() {
    if [[ -z "${PAT:-}" ]]; then
        raise missing "the repository secret ADD_TO_PROJECT_PAT isn't set"
        return
    fi
    local code login scopes need expiry left
    code="$(call -H "Authorization: token ${PAT}" -H "Accept: application/vnd.github+json" "${api}/user")" || exit 2
    if [[ "${code}" != 200 ]]; then
        raise refused "GitHub refused ADD_TO_PROJECT_PAT: HTTP ${code}"
        return
    fi
    login="$(jq -r .login "${work}/body")"
    if [[ "${login,,}" != "${ACCOUNT,,}" ]]; then
        raise wrong-account "ADD_TO_PROJECT_PAT signs in as ${login}, not ${ACCOUNT}"
    fi
    scopes=",$(header x-oauth-scopes | tr -d ' '),"
    for need in $(jq -r '.user.scopes[]' "${config}"); do
        [[ "${scopes}" == *",${need},"* ]] || raise short "ADD_TO_PROJECT_PAT lacks the ${need} scope"
    done
    expiry="$(header github-authentication-token-expiration)"
    [[ -n "${expiry}" ]] || return 0
    left="$(days_until "${expiry}")" || return 0
    if ((left < 0)); then
        raise expired "ADD_TO_PROJECT_PAT expired on ${expiry}"
    elif ((left <= margin)); then
        raise expiring "ADD_TO_PROJECT_PAT expires on ${expiry}, in ${left} days"
    fi
}

# check_watched raises no-recent-check for a watched repository whose latest credentials check is over two days old.
check_watched() {
    local repository latest left
    IFS=',' read -r -a watched <<<"${WATCH:-}"
    for repository in "${watched[@]}"; do
        repository="${repository// /}"
        [[ -n "${repository}" ]] || continue
        latest="$(gh api "repos/${repository}/actions/workflows/credentials-check.yml/runs?per_page=1" \
            --jq '.workflow_runs[0].created_at // ""' 2>/dev/null)" || latest=""
        if [[ -z "${latest}" ]]; then
            raise "no-recent-check in ${repository}" "${repository} has no credentials check run"
            continue
        fi
        left="$(days_until "${latest}")" || continue
        if ((left < -2)); then
            raise "no-recent-check in ${repository}" "${repository}'s latest credentials check ran on ${latest:0:10}"
        fi
    done
}

# incident_for prints the number of the open incident for a condition, or nothing.
incident_for() {
    gh issue list --repo "${REPOSITORY}" --label "${label}" --state open --json number,title --limit 100 \
        --jq ".[] | select(.title == \"Token alert: $1\") | .number" | head -n 1
}

# keep raises, repeats or clears the incident of one condition.
keep() {
    local condition="$1" number last
    number="$(incident_for "${condition}")"
    if [[ -n "${found[${condition}]+held}" ]]; then
        if [[ -z "${number}" ]]; then
            gh issue create --repo "${REPOSITORY}" --title "Token alert: ${condition}" --label "${label}" \
                --assignee "${assignee}" --body "$(printf '%s\n\n%s\n\n%s\n' \
                    "**${condition}:** ${found[${condition}]}, as ${run} found on $(date -u +%Y-%m-%d)." \
                    "This incident gets a comment each day it holds, and closes when a check shows it gone." \
                    "How to fix it: ${guide}")" >/dev/null
            return
        fi
        last="$(gh issue view "${number}" --repo "${REPOSITORY}" --json createdAt,comments \
            --jq '([.createdAt] + [.comments[].createdAt]) | max | .[0:10]')"
        if [[ "${last}" != "$(date -u +%Y-%m-%d)" ]]; then
            gh issue comment "${number}" --repo "${REPOSITORY}" \
                --body "Still holds on $(date -u +%Y-%m-%d): ${found[${condition}]}. ${run}." >/dev/null
        fi
        return
    fi
    if [[ -n "${number}" && "${mode}" != report ]]; then
        gh issue comment "${number}" --repo "${REPOSITORY}" \
            --body "Cleared on $(date -u +%Y-%m-%d): ${run} found it gone." >/dev/null
        gh issue close "${number}" --repo "${REPOSITORY}" >/dev/null
    fi
}

if [[ "${mode}" == report ]]; then
    raise consumer-failed "${DETAIL:-a workflow failed signing in}"
    conditions=(consumer-failed)
else
    case "${KIND}" in
        organization)
            check_app
            check_rotation
            conditions=(missing refused not-installed short rotation-due rotation-overdue consumer-failed)
            ;;
        user)
            check_token
            conditions=(missing refused wrong-account short expired expiring consumer-failed)
            ;;
        *)
            printf 'KIND is organization or user, not %s\n' "${KIND}" >&2
            exit 64
            ;;
    esac
    check_watched
    for repository in "${watched[@]}"; do
        repository="${repository// /}"
        [[ -z "${repository}" ]] || conditions+=("no-recent-check in ${repository}")
    done
fi

gh label create "${label}" --repo "${REPOSITORY}" --color B60205 --force \
    --description "A token this repository's workflows sign in with needs attention" >/dev/null 2>&1 || true
for condition in "${conditions[@]}"; do
    keep "${condition}"
done
for condition in "${!found[@]}"; do
    printf '%s: %s\n' "${condition}" "${found[${condition}]}"
done
((${#found[@]} == 0))

# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""An account's issue-tracking token: the model's token record, the preflight of apply and restore, and what get writes."""

# credentials.star
#
# docs/plans/feature/451-credentials.md, §§ 5.1 and 5.2 (noblefactor-engprod#451). Every account that takes part in
# triage identifies its token, and apply refuses an account that doesn't, before it writes anything; the token's uses
# and permissions are free to change (decided 2026-11-20). The model's token record names the token's kind and, for each
# secret the account's Triage workflow signs in with, where its value comes from: env:<NAME>, file:<path>, or held, a
# secret GitHub holds at every place a workflow reads it (participation.star's bindings). It names no use and no
# permission. A place GitHub refuses to list is unreadable, told from one that lacks the secret. --token names a source
# too, and replaces what the record names.

load("commands/model.star", "quote", "sh")
load("commands/participation.star", "TEMPLATE", "bindings", "read_file", "secrets_held", "secrets_of")
load("commands/tokens.star", "CLEAN", "problem", "reader")

# Each account kind's token.
KIND = {"organization": "github-app", "user": "classic-token"}

# The source of a secret GitHub holds at every place a workflow reads it.
HELD = "held"

# How to make each kind of token, step by step.
GUIDE = "https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/reference/issue-tracking-credentials.md"

def recorded(model):
    """{secret: source} as the model's token record names them, a secret it names no source for left out."""
    token = model.get("token")
    if type(token) != "dict" or type(token.get("secrets")) != "dict":
        return {}
    out = {}
    for name, source in token["secrets"].items():
        if source != None and str(source).strip() != "":
            out[name] = str(source).strip()
    return out

def required(state):
    """The secrets the account's Triage workflow template signs in with, none when there is no template."""
    if state == None or state.get("template") == None:
        return []
    return state.get("secrets") or []

def preflight(account, kind, state, model, tokens):
    """What keeps apply or restore from writing anything to the account: [problem], none when its token is identified.

    Args:
      account: the account.
      kind: "organization" or "user".
      state: what participation.star's read holds of the account.
      model: the model being applied, a reference's in the form get returns.
      tokens: {secret: source} from --token, which replaces what the model's token record names.
    """
    names = required(state)
    if not names:
        return []
    out = []
    token = model.get("token")
    if token != None and type(token) != "dict":
        out.append("the model's token record is not a record")
        token = None
    want = KIND[kind]
    if token != None and token.get("kind") not in [None, want]:
        out.append("the model's token record says its kind is " + str(token.get("kind")) + "; an " + kind +
                   "'s token is " + want)
    sources = recorded(model)
    unnamed = "the model has no token record" if token == None else "the model's token record names none"
    for name in names:
        source = tokens.get(name) or sources.get(name)
        places = bindings(state, kind, account, name)
        refused = [p for p, s in places if s == "unreadable"]
        missing = [p for p, s in places if s == "missing"]
        if refused:
            out.append(name + ": GitHub refused to list the secrets at " + ", ".join(refused) +
                       ", so whether it is held there can't be told; sign in to gh as an account that administers them")
        if source == None:
            out.append(name + " has no source: " + unnamed + ", and --token names none")
        elif source == HELD:
            if missing:
                out.append(name + " is recorded as held, and GitHub doesn't hold it at " + ", ".join(missing))
        elif name not in tokens:
            found = problem(source)
            if found:
                out.append(name + ": the token record's source " + found)
                continue
        if kind == "organization" and name.endswith("_ID") and source not in [None, HELD]:
            if not installed(account, source):
                out.append(name + ": the app whose ID it names isn't installed on " + account +
                           "; install it on all of " + account + "'s repositories")
    return out

def installed(account, source):
    """Whether the app whose ID a source holds is installed on the organization.

    The ID goes to awk on its standard input, ahead of the organization's installations' app IDs, so that it enters no
    command's arguments and never Starlark.
    """
    script = ("{ " + reader(source) + " | " + CLEAN + "; printf '\\n'; gh api --paginate " +
              quote("orgs/" + account + "/installations") + " --jq '.installations[].app_id' 2>/dev/null; } | " +
              "awk 'NR == 1 { id = $0; next } id != \"\" && $0 == id { found = 1 } " +
              "END { print found ? \"yes\" : \"no\" }'")
    return sh(script).strip() == "yes"

def how(account, kind, names):
    """How to make the account's token and name it, as the refusal says."""
    if kind == "organization":
        make = ("create " + account + "'s GitHub App at https://github.com/organizations/" + account +
                "/settings/apps/new with the permissions the guide lists, install it on all of " + account +
                "'s repositories, and generate its private key")
    else:
        make = ("signed in to GitHub as " + account + ", make a classic token at " +
                "https://github.com/settings/tokens/new with the repo and project scopes")
    named = ",".join([n + "=env:<NAME>" for n in names])
    return ("To make the token, " + make + ". Then name where each value comes from, with --token " + named +
            " or file:<path> in place of env:, or in the model's token record; a secret GitHub already holds " +
            "everywhere is recorded as " + HELD + ". The guide: " + GUIDE)

def refusal(account, kind, names, problems):
    """The failure apply and restore stop with when the preflight finds a problem: each one, then how to fix them."""
    head = ("nothing was written: " + account + "'s Triage workflow signs in with a token the model doesn't " +
            "identify, or GitHub doesn't hold where its record says:")
    return "\n".join([head] + ["  " + p for p in problems] + [how(account, kind, names)])

def differences(account, kind, state, model):
    """diff's record for each secret the Triage workflow signs in with that the token record names no source for.

    A secret missing or unreadable where a workflow reads it is participation.star's secret record; this one says the
    model doesn't identify where its value comes from.
    """
    sources = recorded(model)
    out = []
    for name in required(state):
        if name not in sources:
            out.append({
                "kind": "token",
                "path": account + "/" + name,
                "change": "unidentified",
                "github": None,
                "model": {"name": name, "kind": KIND[kind]},
                "by_hand": False,
            })
    return out

def _backup(account):
    """The sources the account's current backup records, model.yaml on its .github repository's default branch."""
    text = read_file(account + "/.github", "model.yaml")
    if text == None:
        return {}
    model = yaml.decode(data = text)
    return recorded(model) if type(model) == "dict" else {}

def read_token(account, kind, repositories):
    """The token record get writes, or None when the account's .github repository holds no Triage workflow template.

    It names each secret the template signs in with that GitHub holds at every place a workflow reads it: as held, or by
    the source the account's current backup records for it, so that a backup keeps a recorded locator. A secret GitHub
    doesn't hold everywhere is left out, since get can't say where its value comes from.
    """
    template = read_file(account + "/.github", TEMPLATE)
    if template == None:
        return None
    names = secrets_of(template)
    state = dict(secrets_held(kind, account, repositories, names), secrets = names, template = template)
    kept = _backup(account)
    secrets = {}
    for name in names:
        if all([s == "held" for _, s in bindings(state, kind, account, name)]):
            source = kept.get(name)
            secrets[name] = source if source and source != HELD else HELD
    return {"kind": KIND[kind], "secrets": secrets}

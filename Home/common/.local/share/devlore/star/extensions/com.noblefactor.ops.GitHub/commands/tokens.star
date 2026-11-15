# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""--token: where each secret the Triage workflow signs in with comes from, never its value."""

# tokens.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, decision 15 (the owner, 2026-11-10). --token names each secret and
# its source, <SECRET>=env:<NAME> or <SECRET>=file:<path>, comma-separated; a bare source serves when the template uses
# one secret. env: is an environment variable set for the run; file: a file its owner alone can read, mode 600 or
# stricter. A value on the command line is refused, since it is in the shell's history already, and so is any other
# source: star calls no other tool for a secret. The value goes from its source to gh secret set through one shell
# pipeline, carriage returns and the final newline dropped and a private key's other lines kept, and so never enters
# Starlark or a record; a record shows the first 12 hexadecimal digits of its SHA-256.
#
# On Windows, where a file has no mode, file: reads the file's ACL with powershell.exe's Get-Acl, part of Windows, and
# refuses a file anyone but its owner, SYSTEM and Administrators can read (the owner, 2026-11-10). That half is untested
# until the command provider replaces the shell provider (NobleFactor/devlore-cli#1136, #474).

load("commands/model.star", "quote", "sh")

# What a source is told when it is refused.
_FORMS = "--token takes <SECRET>=env:<NAME> or <SECRET>=file:<path>, comma-separated, or a bare env:<NAME> or file:<path>"

# The prefixes GitHub gives its tokens, so that a token's value on the command line is named as one.
_TOKEN_PREFIXES = ["ghp_", "gho_", "ghu_", "ghs_", "ghr_", "github_pat_"]

# The security identifiers that may read a token file on Windows besides its owner: SYSTEM and Administrators.
_WINDOWS_READERS = ["S-1-5-18", "S-1-5-32-544"]

# Lines kept, carriage returns and the final newline dropped: a token is one line, an App's private key several.
_CLEAN = "awk 'BEGIN { ORS = \"\" } { sub(/\\r$/, \"\"); if (NR > 1) printf \"\\n\"; print }'"

def _identifier(s):
    """Whether s is a shell variable's or a secret's name: a letter or an underscore, then letters, digits and underscores."""
    if s == "" or s[0].isdigit():
        return False
    for c in s.elems():
        if not (c.isalnum() or c == "_") or ord(c) > 127:
            return False
    return True

def _refuse_value(source):
    """Fails on a source that is neither env: nor file:, naming a token's value as one, which the shell's history holds."""
    if source == "-":
        fail("--token takes no -: star's shell provider gives an extension's commands no standard input " +
             "(NobleFactor/devlore-cli#1136); " + _FORMS)
    looks = [p for p in _TOKEN_PREFIXES if source.startswith(p)]
    if looks:
        fail(_FORMS + ", never a token's value: this one is in your shell's history now, so revoke it")
    prefix = source.split(":")[0] if ":" in source else ""
    if _identifier(prefix):
        fail(_FORMS + ", never another source: " + prefix + ":")
    fail(_FORMS + ", never a value: if this one is a token's, it is in your shell's history now, so revoke it")

def parse(spec):
    """The sources --token names: [(secret, source)], the secret "" for a bare source. Reads nothing."""
    out = []
    for entry in spec.split(","):
        entry = entry.strip()
        if entry == "":
            continue
        secret, source = "", entry
        if not (entry.startswith("env:") or entry.startswith("file:")) and "=" in entry:
            secret, source = entry.split("=", 1)
            if not _identifier(secret):
                fail("--token names a secret by something that is no secret's name, before its =; " + _FORMS)
        if source.startswith("env:"):
            if not _identifier(source[len("env:"):]):
                fail("--token " + source + " names no environment variable; " + _FORMS)
        elif source.startswith("file:"):
            if source[len("file:"):] == "":
                fail("--token file: names no file; " + _FORMS)
        else:
            _refuse_value(source)
        out.append((secret, source))
    return out

def _windows():
    """Whether the shell runs on Windows: Git for Windows', MSYS2's or Cygwin's."""
    return sh("case \"$(uname -s)\" in MINGW* | MSYS* | CYGWIN*) echo windows ;; *) echo unix ;; esac").strip() == "windows"

def _windows_readers(path):
    """The security identifiers other than the file's owner, SYSTEM and Administrators that its ACL lets read it."""
    p = path.replace("'", "''")
    script = ("$acl = Get-Acl -LiteralPath '" + p + "'; " +
              "$owner = (New-Object System.Security.Principal.NTAccount($acl.Owner)).Translate([System.Security.Principal.SecurityIdentifier]).Value; " +
              "$acl.Access | Where-Object { $_.AccessControlType -eq 'Allow' -and " +
              "($_.FileSystemRights -band [System.Security.AccessControl.FileSystemRights]::ReadData) } | " +
              "ForEach-Object { $_.IdentityReference.Translate([System.Security.Principal.SecurityIdentifier]).Value } | " +
              "Where-Object { $_ -ne $owner -and $_ -notin @('" + "', '".join(_WINDOWS_READERS) + "') } | Sort-Object -Unique")
    out = sh("powershell.exe -NoProfile -NonInteractive -Command " + quote(script) + " | tr -d '\\r'")
    return [line for line in out.split("\n") if line.strip() != ""]

def check(sources):
    """Fails unless every source can be read as decision 15 requires: a variable that is set, a file only its owner reads.

    Reads no value: whether a variable is set is asked of the shell, and a file's mode or ACL of the file system.
    """
    for _, source in sources:
        if source.startswith("env:"):
            name = source[len("env:"):]
            if sh("[ -n \"${" + name + ":-}\" ] && echo set || echo unset").strip() != "set":
                fail("--token " + source + ": the environment variable " + name + " is not set, or is empty")
            continue
        path = source[len("file:"):]
        if sh("[ -f " + quote(path) + " ] && [ -r " + quote(path) + " ] && echo yes || echo no").strip() != "yes":
            fail("--token " + source + ": " + path + " is not a file this account can read")
        if _windows():
            others = _windows_readers(path)
            if others:
                fail("--token " + source + ": others can read " + path + ": " + ", ".join(others) +
                     "; let its owner alone read it, SYSTEM and Administrators aside")
            continue
        if sh("[ -O " + quote(path) + " ] && echo yes || echo no").strip() != "yes":
            fail("--token " + source + ": " + path + " belongs to another account; a token file is its owner's alone")
        mode = sh("stat -c %a " + quote(path) + " 2>/dev/null || stat -f %Lp " + quote(path)).strip()
        if len(mode) < 2 or mode[-2:] != "00":
            fail("--token " + source + ": others can read " + path + ", mode " + mode + "; chmod 600 " + path)

def for_secrets(sources, names, where):
    """{secret: source} for the secrets a template uses, failing on a secret it does not use or a bare source it cannot take.

    Args:
      sources: what parse returns.
      names: the secrets the template uses.
      where: the template, as the failure names it.
    """
    out = {}
    for secret, source in sources:
        if secret == "":
            if len(names) != 1:
                fail("--token " + source + " names no secret, and " + where + " uses " + str(len(names)) + ": " +
                     ", ".join(names) + "; name each: <SECRET>=" + source)
            secret = names[0]
        if secret not in names:
            fail("--token names " + secret + ", which " + where + " does not use" +
                 (": it uses " + ", ".join(names) if names else ": it uses no secret"))
        out[secret] = source
    return out

def _read(source):
    """The shell command that writes a source's value to its standard output, never into Starlark."""
    if source.startswith("env:"):
        return "printf %s \"${" + source[len("env:"):] + "}\""
    return "cat " + quote(source[len("file:"):])

def fingerprint(source):
    """The first 12 hexadecimal digits of the SHA-256 of the value a source holds, as it is set."""
    return sh(_read(source) + " | " + _CLEAN + " | { sha256sum 2>/dev/null || shasum -a 256; } | cut -c1-12").strip()

def set_secret(name, source, repository = None, organization = None):
    """Sets a secret from its source through one pipeline: on a repository, or on an organization, visible to all its repositories."""
    target = ("--repo " + quote(repository)) if repository else ("--org " + quote(organization) + " --visibility all")
    sh(_read(source) + " | " + _CLEAN + " | gh secret set " + quote(name) + " " + target)

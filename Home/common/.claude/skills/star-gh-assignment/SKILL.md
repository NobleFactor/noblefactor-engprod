---
name: star-gh-assignment
title: "star gh assignment"
description: Answer "What schedule are you working on?" with the schedule issue's key, `<owner>/<repository>#<number>`, from `$NFEP_AGENT_SCHEDULE`, or from this session's name when it is unset; and "What is your schedule's link?" with `$NFEP_AGENT_SCHEDULE_URL`, or the link the key makes. Triggers on "what are you working on", "what schedule are you working", "what is your assignment", "what is your schedule's link", "link to your schedule", and on `/star-gh-assignment` as a session's first prompt. Never reads the conversation, memory or the branch.
---

# What schedule this session works, and its link

The owner, 2026-10-05: *"star-gh-assignment reports the schedule issue number. that is all."* And:
*"your assignment is always a schedule. always."* On 2026-10-21, of the link (NobleFactor/noblefactor-ops#260):
*"I agree. Give the schedule's link too as you describe."* And, asked whether a link is made from the key when the
variable is absent: *"Yes"*.

## The schedule

1. **The environment.** Start-Claude and Start-Claude.ps1 hand every session they start on a schedule its key,
   through `claude --bg --settings`:

   ```bash
   printenv NFEP_AGENT_SCHEDULE
   ```

   Set, it is the answer, alone: for example `NobleFactor/devlore-cli#916`.

2. **The session's name,** when the variable is unset: the last name record in this session's transcript.

   ```bash
   grep --only-matching --extended-regexp '"type":"custom-title","customTitle":"([^"\\]|\\.)*"' \
       "${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"/projects/*/"${CLAUDE_CODE_SESSION_ID}".jsonl | tail --lines=1
   ```

   A session's name begins with its schedule, `<owner>/<repository>#<number> | `. Answer with that key alone.

3. **Neither:** a name that does not begin with a key has no schedule to report. Answer `none`.

This order, the environment and then the name, is one step of the search path NobleFactor/noblefactor-ops#308 asks
for, which names the agent-schedule store as definitive; the owner has left the path's order open.

## The link

Asked for the schedule's link, answer with it alone, and search nothing for it: not the conversation, GitHub or
memory.

1. `printenv NFEP_AGENT_SCHEDULE_URL`, when it is set.
2. Otherwise the link the key makes, every schedule's link having that form, and GitHub redirecting the link of an
   issue that has moved: `https://github.com/<owner>/<repository>/issues/<number>`.
3. With no key, `none`.

## What it never reads

The conversation (your prompts, the replies, compaction summaries), memory, and the session's branch. The owner:
*"You answer from the metadata, not the transcript."* The environment Start-Claude gives a session and the name it
gives it are that metadata. A session starts in a repository clone on its default branch, and its worktrees come
later, so the branch names no schedule.

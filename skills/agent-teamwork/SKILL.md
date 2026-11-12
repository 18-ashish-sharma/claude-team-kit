---
name: agent-teamwork
description: Use when about to hand work to subagents, run several agents or sessions in parallel, or act on what an agent reported - how to brief them, keep them from colliding, and check their claims before relying on them.
---

# Working with agents

## An agent's report is a hypothesis

"I verified it", "tests pass", "I found a bug at line 40" are claims. Before acting on one or repeating it to a person:

- open the file and read the cited lines yourself;
- re-run the one command that proves it;
- check the line numbers: agents often cite the wrong line, or a line from a different version.

Findings you cannot confirm are dropped, not passed on with a caveat. An agent handed your theory tends to return it confirmed, so brief with the code and the question, not your conclusion.

## Decide whether to delegate at all

Delegate independent work that can run side by side, or a wide search where you only need the answer. Do the work yourself when it is a few tool calls or a lookup whose target you know. Every agent costs tokens and loses detail twice: once in the brief, once in the summary.

## Brief like you would brief a colleague

The brief is all the agent knows. Include:

- the goal, and what "done" looks like;
- what you already ruled out;
- the files and docs to read, by path;
- the scope, and what is out of scope;
- the hard rules (below);
- the format you want back.

If you cannot write a clear brief, you do not understand the task well enough to hand it off.

## Hard rules to put in every brief

- What it may change and what is read-only. Review agents never edit, commit or push.
- No merging, no force-pushing, no deploys.
- No shared, staging or production databases or APIs.
- No secrets printed; nothing private sent to outside services.
- Machine limits: one heavy run at a time, test runners capped at 2 workers, and stop every server, watcher and container it started before reporting back.
- Say what it did not do.

## Keep parallel work from colliding

- **Each agent that edits gets its own git worktree.** Two agents in one folder overwrite each other and commit each other's half-finished files.
- **Agree the contract first.** When one agent builds the API and another the client, write down the paths, fields and error codes before either starts. Parallel agents each invent a slightly different shape.
- **Another session may be editing the same branch.** Review commits, not files on disk, and fetch before building on a branch.
- **One heavy job at a time across all agents.** Parallel test suites on a laptop bring it to a halt.
- **Per-branch green is not merged green.** After parallel branches pass alone, merge them and test the result.

## After they finish

- Verify, then integrate. Run the checks on the combined result.
- Relay what matters to the person; they do not see agent reports.
- Confirm nothing was left running, and remove worktrees that are finished and pushed.

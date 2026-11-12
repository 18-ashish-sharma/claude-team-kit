---
name: machine-guard
description: Use before starting anything heavy on a developer laptop - a test run, a build, a type check, a dev server, Docker, an emulator, or more than two agents - and again when the machine feels slow, and at the end of a session to shut down everything the session started.
---

# Machine guard

A laptop with several sessions, their agents, test workers, type checkers, dev servers and a container runtime will run out of memory and start swapping. Once it swaps, everything is slow, including the work that caused it. Keep memory in check as a habit.

## Before starting anything heavy

```bash
sysctl -n vm.swapusage          # macOS: swap in use
memory_pressure | tail -1       # macOS: free percentage
free -h                         # Linux
```

If swap in use is above about 4 GB, or free memory is under about 30%: free something first, or say so and ask. Do not start the heavy thing and hope.

## While working

- **One heavy run at a time** across the whole session and all its agents: one test run, one build, one type check.
- **Cap the workers.** Test runners get an explicit limit (`--maxWorkers=2`, `-n 2`, `-j 2`). The default is one worker per core, each holding its own copy of the project.
- **Run the narrow thing.** One test file or one package, not the whole suite, unless the whole suite is the point.
- **Check again** after each batch of agents and whenever things feel slow. Do not wait for the person to notice.
- **Tell every agent.** Each agent brief carries these limits and says to stop what it started before reporting back.

## Keep a list of what you start

Ports, process IDs, containers, emulators, worktrees with a running process. Write it down as you go, so closing is not guesswork.

## At the end, close what this session started

Dev servers, test runners and their workers, watchers (`tsc --watch`, bundlers), headless browsers, build daemons (`./gradlew --stop`), emulators, and containers started for the task. Stop the container runtime too if this session started it and nothing else is using it.

Then prove it:

```bash
lsof -iTCP -sTCP:LISTEN -P | grep -E ':(3000|3001|5173|8000|8080)\b'
ps aux | grep -E 'jest|vitest|tsc|next dev|vite|gradle|metro' | grep -v grep
docker ps
```

Report swap before and after.

## Only close what is yours

A process another session started is closed by asking that session or the person, never on a guess. A process whose owner is unknown goes on a list for the person. It is not killed.

## Container runtime

Use the one runtime the team has agreed on; do not add a second. Start it when a task needs it, give it a small memory limit (3 to 4 GB is plenty for a local database), stop containers when the task ends. Most runtimes hold memory up to their limit until restarted.

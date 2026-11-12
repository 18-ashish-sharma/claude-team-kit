---
name: disk-cleanup
description: Use when the disk is filling up or full - "no space left on device", a build or Docker failing for space, the machine warning about storage, or as a routine tidy after a long stretch of work. Finds what is taking the space (build output, dependency folders, caches, Docker, simulators, old worktrees, logs) and clears only what can be rebuilt, after showing the list.
---

# Disk clean-up

Disks fill quietly: every worktree gets its own `node_modules`, every build leaves output, Docker keeps old images, simulators and caches only grow. Clean up as a habit, not when the machine stops.

## The order is fixed: report, propose, confirm, delete, report

1. **Report.** Run the read-only report. It deletes nothing.

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/disk-report.sh" /path/to/projects
   ```

   No path means the current folder. `STALE_DAYS=30` changes what counts as untouched (default 14).

2. **Propose.** Show a short table, largest first: what it is, the size, whether it rebuilds itself, and the command that clears it. Give the total that would be freed.

3. **Confirm.** Wait for a yes. A yes covers the list that was shown, nothing added later.

4. **Delete**, one item at a time, so a failure is easy to see.

5. **Report again**: free space before and after, and anything that was skipped and why.

## Safe to clear (rebuilds itself)

| What | How |
|---|---|
| Dependency folders in projects not touched lately (`node_modules`, `Pods`, `.venv`) | delete the folder; the next install brings it back |
| Build output (`.next`, `dist`, `build`, `.turbo`, `.expo`, `target`, `coverage`, `__pycache__`) | delete the folder |
| Package caches | `npm cache clean --force`, `yarn cache clean`, `pnpm store prune`, `bun pm cache rm`, `pip cache purge`, `brew cleanup -s` |
| Gradle | `./gradlew --stop` first, then delete `~/.gradle/caches` |
| Xcode | delete `~/Library/Developer/Xcode/DerivedData`; `xcrun simctl delete unavailable` |
| Docker | `docker system df` first; then `docker container prune`, `docker image prune -a`, `docker builder prune` |
| Browser test downloads (Playwright, Cypress) | delete the cache folder; the next run downloads again |
| Stale worktree entries whose folder is gone | `git worktree prune` |

## Look first, then decide with the person

- **Git worktrees.** Before removing one: `git -C <path> status --porcelain` must be empty and `git -C <path> rev-list --count @{u}..HEAD` must be 0. A worktree with changed files, unpushed commits, or a branch with no upstream holds work that exists nowhere else. List it; do not remove it. Remove with `git worktree remove <path>`, never `rm -rf`.
- **Docker volumes.** `docker volume prune` and `docker system prune --volumes` delete local databases. Never run them without naming each volume and getting a yes for it.
- **Xcode archives** hold the symbols needed to read crash reports of released builds.
- **Session logs and assistant data** (`~/.claude/projects`) hold conversation history and memory files. Offer to clear old transcripts only; never memory folders.
- **Downloads, documents, exported reports, recordings, screenshots, deliverables.** Not regenerable. Point them out by size and leave the choice to the person.
- **Large model or dataset files.** Regenerable only if the source still exists. Ask.

## Never

- Delete anything outside the list that was approved.
- `rm -rf` a path built from an unset variable or a glob you have not expanded and read. Print the path first.
- Touch another running session's files, a folder with a process running in it, or anything whose owner is unknown. List it for the person.
- Empty the Trash or clear the system temp folder without asking; people park things there.
- Treat "not opened lately" as "not needed". Age picks the candidates; it does not approve them.

## Keeping it from filling again

- When a branch is merged, remove its worktree the same day.
- After a device or emulator test, clean the build (`./gradlew clean`, delete `DerivedData`).
- Give Docker a small disk limit and prune images after each task.
- Send temporary files to a scratch folder that is cleared at the end of the session, not to the project.
- Run the report weekly. The session-start hook in this kit warns when the disk passes 85% (`TEAM_KIT_DISK_WARN_PCT` changes that).

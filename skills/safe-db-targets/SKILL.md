---
name: safe-db-targets
description: Use before running tests, migrations, seed or reset scripts, API collection runs, or one-off SQL - any time a command could write to a database. Makes sure the target is a local database and never a shared, staging or production one.
---

# Safe database targets

Tests, migrations, seeds, resets, API collection runs and fix-up queries go to a **local database**. Never to a shared one.

A shared database holds real data and usually serves more than one service. A test suite that truncates tables, a migration that stops half-way, or a reset script that drops and reseeds takes everyone down with it, and there is no undo.

## Check the target before every write-capable command

1. **Print where it points**, without printing the password:

   ```bash
   node -e 'const u=new URL(process.env.DATABASE_URL);console.log(u.hostname,u.port,u.pathname)'
   python3 -c 'import os,urllib.parse as u;p=u.urlparse(os.environ["DATABASE_URL"]);print(p.hostname,p.port,p.path)'
   ```

2. **It must be local**: `localhost`, `127.0.0.1`, or a container you started. A port-forward or tunnel to a shared database is **not** local, even though the host says `localhost`. Check for one: `ps aux | grep -E 'port-forward|ssh .*-L' | grep -v grep`.
3. **Check the API collection's environment too.** A collection run with the staging or production environment selected writes real data through the API just as surely as SQL does. Run the local environment only.
4. **Read the script before running it.** A harmless name can hide a drop-and-reseed. Know which scripts in the repo are destructive.

## Signs you are pointed at the wrong database

- A local checkout reports every migration as pending, or none, when you expected otherwise.
- Tables hold far more rows than seed data would.
- The names in the data look like real people or real customers.

Fix the target. Do not work around the symptom.

## How shared databases get changed

Only through the release process: the migration job that runs the built, reviewed code. Not from a laptop.

## Contact with a shared environment

Read-only and deliberate: logs, a `SELECT`, a GET through the API. Any **write** needs the owner's explicit go-ahead for that one incident. One approval does not carry over to the next.

After a deploy, smoke-testing with throwaway data is fine, **through the API only**, and the data is named so it can be found and removed.

## When a task seems to need a write to a shared database

Stop and say so. Describe what would be written and why it cannot be checked locally. The decision belongs to the owner.

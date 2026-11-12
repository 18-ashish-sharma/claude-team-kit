# <Service name>: how to run and look after it

*Written from the code on branch `<branch>`, commit `<short sha>`, on <date>. For: the people who deploy and operate it.*

## What it is

<Two or three sentences: what the service does and who depends on it.>

## What it talks to

<Diagram: this service in the middle, what calls it, what it calls.>

| Depends on | Used for | If it is down |
|---|---|---|
| <database / queue / other service / outside API> | <purpose> | <what users see; does this service start, retry, or fail> |

## How it starts

- **Built with**: <language, runtime version, package manager>.
- **Start command**: `<command>`.
- **Listens on**: port <n> (<protocol>).
- **Start-up order**: <for example: connects to the database, runs nothing else, then accepts traffic>.
- **Background work**: <scheduled jobs and queue workers, with their schedule>.

## Settings

Names only. Values live in <where secrets and config are kept>.

| Setting | What it changes | Required | Default | Secret |
|---|---|---|---|---|
| `<NAME>` | <plain effect> | yes / no | <default> | yes / no |

## Data

- **Stores**: <which database and schema, file storage, cache>.
- **Schema changes**: <how migrations run, and when: before deploy, on start, by a job>.
- **Safe to run twice?** <yes / no, and why>.
- **Backups and retention**: <what the code assumes; "not handled in this repository" if so>.

## How it is released

1. <What triggers a release: merge to which branch, a tag, a manual run.>
2. <What the pipeline does, step by step.>
3. <How to confirm the new version is live: version endpoint, image tag, log line.>

**Rolling back**: <how, and what happens to data changed by the newer version>.

## How to tell it is healthy

| Check | How | Healthy looks like |
|---|---|---|
| Is it up | `<health endpoint or command>` | <expected response> |
| Is it working | <a real read-only request> | <expected result> |
| Logs | <where; format> | <the line that shows normal work> |
| Metrics | <where; names> | <normal range if the code states one> |

## Limits built into the code

| Limit | Value | What happens at the limit |
|---|---|---|
| <request timeout / retry count / page size / upload size / rate limit / pool size> | <value with unit> | <behaviour> |

## When something goes wrong

| What you see | Likely cause | First thing to check | Fix |
|---|---|---|---|
| <log line, error, symptom> | <cause> | <read-only check> | <action; who must approve if it changes data> |

## Scheduled jobs

| Job | When | What it does | Safe to re-run | If it fails |
|---|---|---|---|---|
| <name> | <schedule and time zone> | <plain effect> | yes / no | <how you find out; what to do> |

## Things that may surprise you

- <For example: a setting that is read only at start, a job that runs in UTC, a retry that can send a message twice.>

## Not covered

- <Infrastructure defined outside this repository, dashboards, alert rules, and so on.>

## Where this comes from

<Section name: `path:line`, `path:line` ...>

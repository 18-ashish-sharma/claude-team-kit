# <Repository or module name>: a map for newcomers

*Written from the code on branch `<branch>`, commit `<short sha>`, on <date>.*

## What this is for

<Three or four sentences: the problem it solves and who uses it.>

## The parts

<Diagram of the main parts and how they connect.>

| Part | Where | Responsible for | Not responsible for |
|---|---|---|---|
| <name> | `<folder>` | <one line> | <the thing people wrongly assume> |

## How one request travels

<Pick the most typical action and follow it end to end.>

1. <Where it enters> (`path:line`)
2. <What checks it> (`path:line`)
3. <Where the rule lives> (`path:line`)
4. <What it reads and writes> (`path:line`)
5. <What comes back, and what else is triggered>

## Where things live

| If you need to... | Look in |
|---|---|
| add an endpoint or screen | `<path>` |
| change a business rule | `<path>` |
| change the database | `<path>`, and how migrations are run |
| add a setting | `<path>` |
| add a translation | `<path>` |
| find the tests for something | `<path pattern>` |

## Run it on your machine

```bash
<the real commands, in order, as they work today>
```

<What you should see when it works. The local database and test accounts, by name, never passwords.>

## How to check your change

<The commands CI runs, in order. What must be updated together: docs, generated spec, API collection.>

## Conventions you will be expected to follow

- <Naming, folder layout, error handling, how responses are shaped, branch and PR rules.>

## Traps

- <Things that cost people time: a generator that must be re-run, a cache, an order of steps, a setting read only at start.>

## Words used here

| Word | Means |
|---|---|
| <domain term> | <plain meaning> |

## Not covered

- <What this document leaves out.>

## Where this comes from

<Section name: `path:line`, `path:line` ...>

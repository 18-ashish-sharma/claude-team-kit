# claude-team-kit

**One clone. The whole team gets the same Claude Code setup.**

Skills, agents and guard rails for reviewing, testing, coding, handling secrets, keeping a
laptop healthy, and explaining code to people who do not read code. Plus one installer that
brings in ECC, gstack, superpowers, Claude's document skills and 53 community skills, each from
its own source.

```bash
git clone https://github.com/18-ashish-sharma/claude-team-kit.git
cd claude-team-kit
./setup.sh
```

Restart Claude Code, then type `/team-kit:team-kit-guide`.

---

## What you get

| | Count | Where it comes from |
|---|---|---|
| **Team skills** | 19 | this repository |
| **Team agents** | 14 | this repository |
| **Hooks** | 2 | this repository: session briefing, secret guard |
| **ECC** | agents, language reviewers, workflow skills | installed from its repository |
| **gstack** | browser, QA, ship, PDF and diagram skills | installed from its repository |
| **superpowers and official plugins** | planning, debugging, TDD, library docs | official Claude marketplace |
| **Document skills** | Word, PDF, PowerPoint, Excel | Anthropic's skills repository |
| **Community skills** | 53 | 12 author repositories, fetched at install time |

Nothing third-party is stored here. The installer downloads each project from its author, so
you always get their current version and their licence stays intact. See [CREDITS.md](CREDITS.md).

---

## Things you can ask once it is installed

| You say | What happens |
|---|---|
| "Explain how login works, simply" | `explain-code-simply` follows the real code and tells the story in plain words |
| "Write this service up for DevOps" | `code-to-plain-doc` produces an operations document: how it starts, its settings, how it is released, how to tell it is healthy, what to do when it breaks |
| "Write this module up for the client" | `code-to-plain-doc`, business view: who can do what, the rules, the statuses, what users see when it fails |
| "Is this PR ready?" | `pr-loop`: fresh review, specialist reviewers, every CI step locally, run it like a user, docs and spec updated |
| "Review these three PRs" | `reviewing-prs`: one fresh agent per PR, every finding checked against the code before it is posted |
| "QA the leave request flow" | `qa-flow-tester` drives the whole flow, tries the awkward cases, watches the network |
| "Fix this bug" | `bug-fixer` reproduces it first, fixes the cause, adds a test that fails without the fix |
| "Build this endpoint" | `implementer` follows the project's patterns, writes tests, runs the project's checks |
| "My disk is full" | `disk-cleanup` shows what is using space, waits for a yes, clears only what rebuilds itself |
| "Make a user guide PDF" | `guide-pdf`: diagram-first, real screenshots, a 3-page sample before the full guide |
| "Convert this Word file to PDF" | `convert-docs` picks the tool, converts locally, checks the result |
| "Write a message for the client" | `plain-updates`: plain words, ready to paste |
| "Is there an open-source tool for this?" | `oss-scout` compares options with licence and activity |

---

## Team skills (19)

### Understand and explain

| Skill | Use it when |
|---|---|
| `explain-code-simply` | you want code, a flow or a repository explained in simple language, in chat |
| `code-to-plain-doc` | you need a document from the code for non-technical readers, DevOps, or a new developer |
| `plain-updates` | writing a status update, a summary, or a message someone will send |
| `prove-before-posting` | about to post a reply, release note or PR text that people will rely on |

`code-to-plain-doc` has three reader views, each with a template:

| View | For | Covers |
|---|---|---|
| Business | product, clients, managers, testers, support | who can do what, step-by-step flows, the rules with examples, statuses, messages, what goes wrong |
| Operations | DevOps and whoever runs it | dependencies, start-up, settings (names only), data and migrations, release and rollback, health checks, limits, a what-to-do-when table |
| Newcomer | a developer new to the code | the parts, how a request travels, where to change things, how to run and check it, traps |

### Review and test

| Skill | Use it when |
|---|---|
| `pr-loop` | a PR is open and needs to get to ready |
| `reviewing-prs` | reviewing teammates' pull requests |
| `scenario-matrix` | about to call a change tested or done |
| `qa-like-a-user` | verifying in a real browser or on a real device |
| `defect-patterns` | reviewing a diff or hunting a bug the tests missed |
| `docs-spec-collection` | an API endpoint changed: docs, then generated spec, then API collection |

### Safety

| Skill | Use it when |
|---|---|
| `handling-secrets` | anything touches keys, tokens or `.env` files, or a secret leaked |
| `safe-db-targets` | about to run tests, migrations, seeds or one-off SQL |
| `git-identity` | first commit in a repository, several GitHub accounts, or a 403/404 on a repository that exists |

### Machine health

| Skill | Use it when |
|---|---|
| `disk-cleanup` | the disk is filling up |
| `machine-guard` | before a heavy run, when the laptop is slow, and at the end of a session |

### Documents

| Skill | Use it when |
|---|---|
| `guide-pdf` | a user guide or handout is needed as a PDF, in one or two languages |
| `convert-docs` | a document has to change format: Markdown, Word, PDF, HTML, spreadsheets, scans |

### Working method

| Skill | Use it when |
|---|---|
| `agent-teamwork` | handing work to agents, running several in parallel, or acting on what one reported |
| `team-kit-guide` | you want to know what is here and which tool fits a job |

---

## Team agents (14)

### Coding

| Agent | What it does |
|---|---|
| `implementer` | builds one scoped task: reads the neighbours, follows the project's patterns, writes tests, runs every CI step locally |
| `bug-fixer` | reproduces first, finds the cause, makes the smallest fix, adds a failing-then-passing test, checks the neighbouring paths |
| `test-writer` | writes tests from the user's side and proves each one fails when the code it guards is broken |

### Review

| Agent | What it does |
|---|---|
| `pr-reviewer` | a fresh reviewer with no memory of writing the change; every finding has a file, a line and a failing case |
| `finding-verifier` | treats each review finding as a claim and tries to disprove it before anything is fixed or posted |
| `silent-failure-reviewer` | hunts for errors that hide: swallowed exceptions, failures shown as empty lists |
| `ui-code-reviewer` | screens as code: states, touch targets, accessibility, translations, forms |
| `release-readiness-reviewer` | a release gate: what breaks for real users on real devices and bad networks |

### QA

| Agent | What it does |
|---|---|
| `qa-flow-tester` | drives a whole business flow through the UI or API, tries negative cases, reports with evidence |
| `test-suite-auditor` | judges the tests themselves: would they catch a broken product? |

### Understand

| Agent | What it does |
|---|---|
| `codebase-guide` | answers "where is X" and "how does Y work" with file paths and evidence |
| `db-explorer` | answers schema questions from migrations and read-only queries on the local database |
| `plain-doc-writer` | writes the `code-to-plain-doc` document for a repository or module |
| `oss-scout` | finds and compares open-source options before you build something |

Review and QA agents are read-only. Coding agents commit to their own branch and never merge,
force-push or deploy.

---

## Guard rails that run by themselves

**Session briefing.** At the start of each session Claude is told the date, the active GitHub
account, the email this repository commits as, unfinished work, and a warning when the disk
passes 85% or swap passes 4 GB.

**Secret guard.** Before every `git commit` and `git push` that Claude runs, the change is
scanned. If it contains a secret-looking value (cloud keys, tokens, private keys, a database
URL with a password) or a file such as `.env`, a private key or a keystore, the command is
stopped and the reason is shown, with the value never printed. It uses
[gitleaks](https://github.com/gitleaks/gitleaks) when installed, plus a built-in list that
always runs.

To cover commits made by hand too, install it as git hooks in a repository:

```bash
scripts/install-git-guard.sh /path/to/repo
```

Switch either off with `TEAM_KIT_SESSION_BRIEF=off` or `TEAM_KIT_SECRET_GUARD=off`.

---

## Disk clean-up

```bash
scripts/disk-report.sh ~/code      # read-only: shows where the space went
```

The report covers package caches (npm, pnpm, yarn, bun, pip, uv, Gradle, Maven, CocoaPods,
Homebrew), Xcode and simulators, Android emulators, Playwright and Cypress downloads, Docker,
assistant temp files, stale `node_modules` and build folders, git worktrees, and large files.

Then say "clean up my disk" in Claude Code. The skill shows a list with sizes and the command
for each, waits for a yes, and reports free space before and after. It will not:

- remove a worktree that has changed files or unpushed commits;
- prune Docker volumes without naming each one, because that is where local databases live;
- delete documents, downloads, recordings or anything that cannot be rebuilt.

---

## What the installer adds from other projects

`./setup.sh` asks before each step. `--all` says yes to everything, `--kit` installs only this
plugin, `--status` shows what is installed and changes nothing.

| Step | What it adds | Good for |
|---|---|---|
| ECC | language reviewers (TypeScript, Python, Go, Java, Kotlin, Swift, Rust and more), build fixers, security and database reviewers, planning and TDD workflows | deep review in the language you are using |
| superpowers, context7, frontend-design, code-simplifier | brainstorming, written plans, systematic debugging, test-first work, current library docs | thinking before building |
| gstack | `/browse`, `/qa`, `/ship`, `/review`, `/make-pdf`, `/diagram`, `/investigate`, `/retro` and more | driving a real browser, shipping PRs, print-quality PDFs |
| genjutsu, gsap-skills | motion and animation for web and mobile | interface polish |
| Document skills | create and edit Word, PDF, PowerPoint and Excel files | deliverables |
| Community skills | 53 skills, below | role experts, cloud and DevOps, design, three.js |

### Community skills (53)

```bash
scripts/install-extra-skills.sh --list             # the whole catalogue with sources
scripts/install-extra-skills.sh --group design     # one group
scripts/install-extra-skills.sh --only senior-qa,terraform-patterns
```

| Group | Skills |
|---|---|
| **engineering** (16) | senior-architect, senior-backend, senior-frontend, senior-fullstack, senior-qa, senior-secops, senior-security, code-reviewer, aws-solution-architect, azure-cloud-architect, ci-cd-pipeline-builder, database-designer, observability-designer, secrets-vault-manager, helm-chart-builder, terraform-patterns |
| **design** (25) | ui-ux-pro-max, design-system, ui-styling, brand, brandkit, banner-design, slides, design-taste-frontend, high-end-visual-design, minimalist-ui, industrial-brutalist-ui, redesign-existing-projects, image-to-code, imagegen-frontend-web, imagegen-frontend-mobile, taste-design, design-md, enhance-prompt, shadcn-ui, react-vite-dashboard, interface-design, nothing-design, apple-hig-designer, motion-design, web-asset-generator |
| **threejs** (10) | animation, fundamentals, geometry, interaction, lighting, loaders, materials, postprocessing, shaders, textures |
| **testing** (1) | playwright-cli |
| **workflow** (1) | task-observer |

Each installed skill gets a `.source` file naming the repository and commit it came from. Two
more (`d3-viz`, `web-design-guidelines`) are listed but skipped by default because their
repositories state no licence; `--include-unlicensed` fetches them.

---

## Install only the plugin

From inside Claude Code, without cloning:

```
/plugin marketplace add 18-ashish-sharma/claude-team-kit
/plugin install team-kit@claude-team-kit
```

## Update and remove

```bash
claude plugin marketplace update claude-team-kit     # get the latest team-kit
scripts/install-extra-skills.sh --force              # refresh community skills
claude plugin uninstall team-kit@claude-team-kit     # remove
```

## Your own rules file

`templates/CLAUDE.md` is a starting rules file for a person or a team: git authorship, who may
merge, local-only databases, what "done" means, time zones, machine habits. Copy it and fill in
the blanks. Keep names, hosts and customer details in your private copy.

---

## Repository layout

```
.claude-plugin/     plugin and marketplace manifests
skills/             19 team skills (one folder each, with SKILL.md)
agents/             14 team agents
hooks/              session briefing and secret guard wiring
scripts/            secret-guard, session-brief, disk-report, install-git-guard,
                    install-extra-skills, scan-private
catalog/            extra-skills.tsv: every community skill with repository, path and licence
templates/          CLAUDE.md starting rules
tests/              secret guard tests (18 cases)
setup.sh            the installer
```

## What is deliberately not here

- No secrets, tokens, hostnames, customer names or personal settings.
- No copies of other people's work. Everything third-party is fetched from its source.
- No personal `settings.json`. The hooks ship with the plugin and can be switched off.

## Requirements

Claude Code, git, bash, and python3 for the secret guard hook. Optional: `gitleaks` for a
fuller secret scan, `pandoc` for document conversion, Bun for gstack.

macOS is the main target. The hooks, secret guard and installers also run on Linux; the disk
report lists macOS cache locations and skips any that do not exist.

## Contributing

Add a folder under `skills/` with a `SKILL.md`, or a file under `agents/`. Write the
`description` as *when* to use it, in the words someone would type. Keep it general: no
customer names, people, hostnames or internal project names. Before pushing:

```bash
tests/secret-guard-test.sh
scripts/scan-private.sh
claude plugin validate .
```

See [SECURITY.md](SECURITY.md) for what the hooks read and how to report a problem.

## Licence

MIT for everything in this repository. See [LICENSE](LICENSE). Projects fetched by the
installers keep their own licences; see [CREDITS.md](CREDITS.md).

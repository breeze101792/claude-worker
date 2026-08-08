---
name: org-chart
description: The HR department playbook. Use when interviewing the user about hiring agents, recruiting new team members, generating a new opencode agent or subagent, validating agent files, or updating the org roster. Load this skill before creating, editing, or reviewing any agent definition.
---

# Org Chart — The Agent Company

This is the constitution of the user's agent team. It describes the org, how
hiring works, and the exact, validated format every agent file must follow so
opencode starts cleanly.

## Org structure

```
org (user's agent company)
└── HR department
    ├── hr         (primary) head of people — interviews, proposes, approves
    └── recruiter  (subagent) — writes the hire file, updates the roster
└── team members (subagents) — tester, + anything the HR department hires
```

The whole org is tracked in the roster: `opencode/org/ROSTER.md` in the org
repo. Read it before hiring so you never duplicate a role or a name.

## Where hires live

| Scope | Path |
|-------|------|
| Global team (this org repo) | `opencode/agents/<name>.md` |
| Project team | `<project>/.opencode/agent/<name>.md` |

Decision rule: when the user is working inside a project (a git repo that is
not this org repo) and wants a role scoped to that project, hire at
`<project>/.opencode/agent/`. When the user says "my team", "global", or wants
the role available everywhere, hire into the org repo's `opencode/agents/`.
When the current working directory is the org repo itself, hire into
`opencode/agents/`.

The org repo can be found by locating `opencode/agents/tester.md` (glob for
it) or by the git remote; `/home/shaun/projects/tools/claude-worker` and
`/mnt/projects/tools/claude-worker` are the same directory.

## Valid agent file

An agent file `<name>.md` lives in an agents dir. It has YAML frontmatter +
a body. The body becomes the agent's prompt.

```markdown
---
description: What the agent does and when to use it. One to two sentences.
mode: subagent
model: provider/model-id
permission:
  edit: deny
---

You are <name>. Write the full role definition here: job, boundaries, workflow,
guardrails.
```

### Frontmatter allowed fields (schema)

`name, model, variant, description, mode, hidden, color, steps, options,
disable, temperature, top_p, permission`. Any other field is silently routed
into `options` — avoid it. Rules:

- `description` — required on every agent. One to two sentences, front-load
  the trigger keywords. Written to help other agents decide when to use it.
- `mode` — required. One of `primary`, `subagent`, `all`. `primary` = a
  selectable agent (needs a real model + tools). `subagent` = launched via the
  task tool; the main agent talks to the user.
- `model` — always has a provider prefix: `provider/model`. For this org:
  `opencode/deepseek-v4-flash-free` (default), `opencode/deepseek-v4-pro:cloud`
  (more capable/reasoning), `opencode/glm-5.2:cloud`, etc. If unsure which a
  role needs, default to `opencode/deepseek-v4-flash-free`. A primary agent
  without `model` inherits the user's default.
- `permission` — flat action or `{tool: action}` map. Needed to lock down a
  hire: e.g. `edit: deny` for pure-readers, or allow for writers.
- Do NOT put a `prompt` key in frontmatter — the body IS the prompt.

## Hire workflow (the recruiting pipeline)

1. **Interview.** `hr` talks to the user: what are they building, what's
   stuck, which team member is missing. From the current project (manifests,
   source), `USER.md`, and the roster, propose a list of role(s). Never invent
   a tool or permission the user didn't mention.
2. **Propose.** Deliver candidate hires as a shortlist: name, role, model,
   mode, permissions, location (project or global), and the job description
   (the body). Update it against the roster — no duplicate names or duped
   roles.
3. **One-click approval.** Put the final shortlist in a `question` tool call
   with a single "Approve hires" option — the user clicks once and then it
   generates. Do not write a file before that click. If the user rejects with
   edits, adjust and re-confirm exactly once, then proceed.
4. **Generate.** `hr` passes the approved shortlist to the `recruiter`
   subagent via the task tool. The `recruiter` writes one valid `<name>.md`
   per hire, then updates `ROSTER.md`.
5. **Validate.** Re-read every written file and run the checklist below.
6. **Report + restart.** Show a summary and tell the user to quit and restart
   opencode — config loads once; hires activate only after restart. Already
   -roster rows that are not yet active.

## Roster format

`opencode/org/ROSTER.md` — single markdown table from the `## Team` header on,
one row per agent:

| Agent | Role | Mode | Model | Permissions | Hire | Status |

When hiring, append a row. Never remove rows; statuses change to
`retired`/`archived` if a member is decommissioned. Active = loaded, will be
active = awaiting restart.

## Guardrails / hire checklist

- Load this skill first when hiring or reviewing an agent.
- Read `ROSTER.md` and list existing agents before proposing — no duplicates.
- Never overwrite an existing agent file without asking.
- Validate: mode in `primary|subagent|all`; model has a provider prefix;
  `description` present; `prompt` never a frontmatter key; file name =
  agent name (hyphen-separated); YAML parses (no unquoted `#`/`:`, consistent
  indentation, quotes on the values that contain special chars).
- Subagents run with the task tool by the main agent — keep their scope: one
  staff role, do one job per member.
- Never add personal debate; user said plain English only.
- Do not fabricate tools, permissions, or models that don't exist in the
  config — default `permission` to omit when in doubt.
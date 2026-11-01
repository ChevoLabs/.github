# ChevoLabs/.github

Organization-wide defaults for **ChevoLabs** repositories. **This repository is public**: it contains only generic,
reusable material. Never put secrets, internal URLs, account ids, customer data or project-specific details here —
each project keeps those in its own private configuration repository.

| Path | What it does |
|---|---|
| `profile/README.md` | The public organization profile shown on github.com/ChevoLabs |
| `SECURITY.md`, `SUPPORT.md`, `CONTRIBUTING.md`, `PULL_REQUEST_TEMPLATE.md`, `ISSUE_TEMPLATE/` | Default community health files: GitHub uses them for every ChevoLabs repository that has no file of its own. Projects override them by adding their own files to each repository's `.github/` folder |
| `.github/workflows/reusable-*.yml` | Reusable CI workflows: `reusable-secret-scan` (gitleaks), `reusable-node-ci` (npm), `reusable-terraform-ci` (fmt, validate, TFLint, OIDC plan) |
| `.github/workflows/self-check.yml` | actionlint + gitleaks for this repository |
| `workflow-templates/` | Starter workflows shown under **Actions → New workflow → By ChevoLabs** |
| `templates/` | Files to copy into a repository: `.editorconfig`, `.gitattributes`, `.gitleaks.toml`, `.pre-commit-config.yaml`, `.nvmrc`, `githooks/pre-push`, `gitignore/`, `dependabot/` (`node`, `terraform`, `actions-only`), `CODEOWNERS`, `rulesets/main.json` |
| `labels.json` | Organization labels: `type:*`, `priority:*`, `blocked`, `dependencies` |
| `scripts/create-repo.sh` | Create a repository with the standard settings |
| `scripts/sync-labels.sh` | Apply `labels.json` (or a project's own file with `--labels`) to repositories |

## Using the reusable workflows

```yaml
jobs:
  secrets:
    uses: ChevoLabs/.github/.github/workflows/reusable-secret-scan.yml@v1
    permissions:
      contents: read
```

Callers pin to the **`v1` tag**. To release a change: merge to `main`, then move the tag:

```bash
git tag -f v1 && git push -f origin v1     # breaking changes: create v2 instead
```

If the organization requires SHA pinning for reusable workflows too, pin callers to the commit SHA of the tag;
Dependabot (`github-actions` ecosystem) keeps those pins current.

## New repository checklist

```bash
scripts/create-repo.sh <name> "<description>" "<topic1,topic2>"
scripts/sync-labels.sh ChevoLabs/<name>
```

Then copy the baseline from `templates/` (and the project's own files, if it has a configuration repository), run
`git config core.hooksPath .githooks` in the clone, and add CI with a starter from **Actions → New workflow**.

## Rules for changes

- Keep everything generic: no product names, domains, customer contacts or planning ids.
- Third-party actions are pinned to a **full commit SHA** with the version in a comment.
- Every job sets the smallest `permissions:` it needs.
- Tools downloaded in workflows are **checksum-verified**.
- Pull request first; `self-check` must pass.

© ChevoLabs. All rights reserved. The contents are shared for use by ChevoLabs repositories.

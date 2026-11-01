# Contributing to ChevoLabs repositories

These rules apply to every ChevoLabs repository unless the repository has its own `CONTRIBUTING.md` (project
repositories usually add project-specific rules on top of these).

## Flow

1. Create an issue (or pick one) and reference any planning or decision id the project uses.
2. Branch from `main`: `<type>/<short-description>` — e.g. `feat/search-suggestions`, `fix/upload-size`,
   `chore/deps-weekly`.
3. Commit using **Conventional Commits**: `feat: …`, `fix: …`, `docs: …`, `chore: …`, `ci: …`, `refactor: …`,
   `test: …`, `infra: …`. Commits are signed.
4. Open a pull request using the template. CI must pass. Review your own diff line by line before merging.
5. **Squash and merge**; the branch is deleted automatically.
6. Never push directly to `main` (a `pre-push` hook blocks it where branch protection is not available).

## Secrets and personal data

- Never commit secrets, tokens, keys, `.env` files, Terraform state, personal data or production data exports.
- Secrets live in the cloud provider's secret store (for example AWS SSM Parameter Store `SecureString`). GitHub holds
  **no cloud access keys** — workflows use short-lived OIDC roles.
- `gitleaks` runs in pre-commit and CI. If it flags something real: **rotate the secret first**, then clean history.

## Code

- Lockfiles are committed; installs use `npm ci`.
- New dependencies need a reason in the pull request description.
- Third-party GitHub Actions are pinned to a full commit SHA.
- Logs never contain tokens, email addresses, phone numbers or full addresses.

## Infrastructure as code

- Every change goes through a pull request with a CI plan; apply only from an up-to-date `main`.
- Never put secret values in Terraform; never recreate long-lived resources (DNS zones, state buckets) by hand.

## Documentation

When a change alters documented behaviour, update the project's documentation in the same week and add a change-log
line.

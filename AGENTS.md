# Repo
- Each project lives in its own subfolder (e.g. my-app/).
- This repo is public. Never create or write secrets (.env, API keys, tokens, passwords).
- Browser automation (Playwright) must not save files in this repo; .playwright-mcp/ is gitignored.

# Git
- Do not run git init, commit, or push. A hook auto-commits and pushes after each response.
- Do not create nested git repositories in subfolders.

## Archive
- Finished projects may be hidden locally via git sparse-checkout; they still exist on GitHub. Never delete files to free space.
- If a needed folder is missing, tell the user to run `git sparse-checkout disable` instead of recreating it.

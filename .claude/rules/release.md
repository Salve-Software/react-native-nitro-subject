# Release

Releases are made by semantic-release from the commits on `main`, through the manual **Release** workflow. The commit type decides the version, so pick it carefully:

| Commit | Bump |
|---|---|
| breaking change | major |
| `feat` | minor |
| `fix`, `perf`, `refactor`, `docs`, `chore`, revert | patch |
| `test`, `ci`, `build`, `style` | none |

- Don't edit `version` in `package.json` or `CHANGELOG.md` by hand.
- Keep `conventional-changelog-conventionalcommits` on v9. v10 needs a newer changelog writer than `@semantic-release/release-notes-generator` ships, and the release fails.
- npm publishing uses trusted publishing (OIDC), configured on npmjs.com for `release.yml`. No `NPM_TOKEN`.
- Never publish to npm without the maintainer asking.

Details in `docs/releasing.md`.

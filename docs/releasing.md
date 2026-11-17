# Releasing

Releases are cut by [semantic-release](https://github.com/semantic-release/semantic-release) from the Conventional Commits on `main`, through the manual **Release** workflow (Actions → Release → Run workflow). It bumps `package.json`, updates `CHANGELOG.md`, tags `vX.Y.Z`, creates the GitHub release and publishes to npm with [trusted publishing](https://docs.npmjs.com/trusted-publishers) (OIDC — no `NPM_TOKEN`).

| Commit type | Release |
| --- | --- |
| breaking change | major |
| `feat` | minor |
| `fix`, `perf`, `refactor`, `docs`, `chore`, revert | patch |
| `test`, `ci`, `build`, `style` | none |

## First release

Trusted publishing can only be configured for a package that already exists on npm, so the first version is published by hand:

1. Run **Release** with **Publish to npm** unchecked. It tags `v1.0.0`, commits the version bump and changelog to `main` and creates the GitHub release — but does not publish.
2. Publish that exact commit from your machine:

   ```sh
   git fetch --tags && git checkout v1.0.0
   yarn install --immutable && yarn build
   npm publish
   ```

3. On npmjs.com, open the package → Settings → Trusted Publisher → GitHub Actions: organization `Salve-Software`, repository `react-native-nitro-subject`, workflow `release.yml`.

From then on, run **Release** with **Publish to npm** checked.

# Releasing

Releases are made with semantic-release from the commits on `main`. Run the **Release** workflow manually in GitHub Actions. It updates the version and `CHANGELOG.md`, creates the tag and GitHub release, and publishes to npm using trusted publishing (no token).

| Commit | Version bump |
|---|---|
| breaking change | major |
| `feat` | minor |
| `fix`, `perf`, `refactor`, `docs`, `chore`, revert | patch |
| `test`, `ci`, `build`, `style` | none |

## First release

Trusted publishing can only be set up after the package exists on npm, so the first version is published manually:

1. Run **Release** with **Publish to npm** unchecked. This creates the `v1.0.0` tag, the changelog and the GitHub release, without publishing.
2. Publish that tag from your machine:

   ```sh
   git fetch --tags && git checkout v1.0.0
   yarn install --immutable && yarn build
   npm publish
   ```

3. On npmjs.com, go to the package settings and add a trusted publisher: GitHub Actions, organization `Salve-Software`, repository `react-native-nitro-subject`, workflow `release.yml`.

After that, run **Release** with **Publish to npm** checked.

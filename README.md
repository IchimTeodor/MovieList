## Agile Freaks iOS Coding Challenge

A Tuist-managed SwiftUI app for iOS 17+ that surfaces AniList's top-rated movies. The experience mimics the provided Figma inspiration while fulfilling the challenge requirements:

- Home screen fetches a curated movie list (AniList movie search sorted by score).
- Detail screen performs a GraphQL lookup against `https://graphql.anilist.co`.
- Architecture follows MVVM with a lightweight router built on `NavigationStack`.

### Getting Started

1. Ensure Xcode 16+ and Swift 5.10 are installed.
2. From the repo root run:

   ```bash
   ./Scripts/bootstrap.sh
   ```

   The script installs Tuist (if missing), resolves dependencies, and generates the Xcode workspace.
3. Open `MovieBrowser.xcworkspace` and run the `MovieBrowser` scheme on an iOS 17 simulator or device.

### Regenerating GraphQL Models

If you change the queries or schema under `LocalPackages/MovieBrowserFeature/GraphQL`, regenerate the Apollo models by running:

```bash
./Scripts/generate-apollo.sh
```

### Project Structure

```
LocalPackages/
 ├─ DesignSystem                     # Shared FilmKu-inspired tokens (colors, layout, gradients)
 ├─ MovieBrowserFeature
 │   ├─ MovieBrowserDomain           # Entities + navigation destinations
 │   ├─ MovieBrowserService          # GraphQL schema + Apollo-backed MovieService
 │   ├─ MovieBrowserPresentation     # SwiftUI views + view models (with onNavigate closures)
 │   └─ MovieBrowserComposition      # Composer wiring dependencies into presentation
 └─ MovieBrowserNavigation           # TestNav-inspired Router protocol/factory SPM
Targets/AppHost                      # Thin executable target hosting composer + router extensions
MovieBrowserPresentationTests        # Unit tests (service + presentation) executed via Tuist test plan
```

### Implementation Notes

- **Clean architecture**: The feature uses a layered structure (Domain → Service → Presentation → Composition). The app target depends only on the composition library, which outputs fully configured SwiftUI views.
- **Navigation architecture**: The `MovieBrowserNavigation` package now exposes a generic `Router` protocol plus helper factories. The app defines its own `Route` enum (type-aliased locally) and plugs concrete view builders into the `NavigationFactory`, so the navigation SPM never depends on feature code while still wiring everything into `NavigationStack`, sheets, and full-screen covers.
- **Navigation closures**: Every view model receives an `onNavigate: (MovieDestination) -> Void` closure during initialization. Views trigger navigation through exposed helpers (e.g., `viewModel.didSelect(movie:)`), keeping routing logic out of the presentation code.
- **Async loading**: View models only expose `async` APIs (`loadInitialIfNeeded()`, `refresh()`, etc.). SwiftUI views invoke these through `.task`, `.refreshable`, or button-triggered `Task {}` blocks so long-running work always originates from the view layer.
- **Networking**: All requests go through Apollo's GraphQL client, so there is no REST layer to maintain.
- **Testing**: `MovieServiceTests` validate both the happy path and error handling for the service layer using lightweight mocks.

### Running Tests

The test suite lives under the `MovieBrowser+UnitTests` scheme, which runs `MovieBrowserPresentationTests.xctestplan`. You can drive it directly via Xcode:

```bash
xcodebuild test \
  -workspace MovieBrowser.xcworkspace \
  -scheme MovieBrowser+UnitTests \
  -testPlan MovieBrowserPresentationTests \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0'
```

### Next Steps & Ideas

- Add snapshot tests for both feature screens.
- Expand filtering to let users switch between different AniList lists (popular, trending, etc.).
- Cache responses and posters for offline browsing.

## License

This project is distributed under the [PolyForm Noncommercial License 1.0.0](LICENSE), which forbids commercial use.

# Repository Guidelines

## Project Structure & Module Organization

- `moonforge/` contains the Flutter application. Primary entry points are `moonforge/lib/main.dart` and `moonforge/lib/app.dart`.
- `moonforge/lib/` holds app code, including `lib/core/`, `lib/layout/`, and `lib/data/` for services, UI layout, and data access.
- `moonforge/assets/` contains app assets (logos, images). Generated assets and localizations live in `moonforge/lib/gen/` and `moonforge/lib/l10n/`.
- `supabase/` stores Supabase configuration and type generation artifacts.
- `powersync/` includes PowerSync configuration (`powersync/sync-rules.yaml`).

## Build, Test, and Development Commands

Run these from `moonforge/` unless noted:

- `flutter pub get` to install Dart and Flutter dependencies.
- `flutter run` to start the app on a connected device or emulator.
- `flutter build windows|macos|ios|android|web` to produce platform builds.
- `dart run build_runner build --delete-conflicting-outputs` to regenerate code for generators (auto_route, riverpod, drift, envied).
- `dart run tools/generate_database_classes.dart` to regenerate database classes when schema changes.

## Coding Style & Naming Conventions

- Dart formatting follows `flutter format` defaults; keep 2-space indentation and trailing commas for multi-line literals.
- Linting uses `flutter_lints` plus `riverpod_lint` (`moonforge/analysis_options.yaml`). Resolve analyzer warnings before shipping.
- Prefer lower_snake_case for file names and UpperCamelCase for classes. Generated files live in `lib/gen/` and `lib/routes/app_router.gr.dart`.

## Testing Guidelines

- Tests use `flutter_test`. Run with `flutter test`.
- Place tests under `moonforge/test/` and name files `*_test.dart`.

## Commit & Pull Request Guidelines

- No commit history exists yet in this repo, so follow a simple convention like `type: short summary` (e.g., `feat: add campaign import`).
- Pull requests should include a brief description, screenshots for UI changes, and any relevant issue links.

## Configuration Tips

- Environment values are expected in `moonforge/.env` (listed in `pubspec.yaml` assets). Do not commit secrets.

## Additional Tips
- use dart mcp with tool pub_dev_search, if you are not sure about a package
- you can use dart mcp for generell commands like dart_fix, analyze_files and more
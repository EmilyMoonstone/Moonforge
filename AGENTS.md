# Repository Guidelines

## Project Overview (Where to Look)

- App entry and routing: `moonforge/lib/main.dart`, `moonforge/lib/app.dart`, `moonforge/lib/routes/`.
- Feature UI and screens: `moonforge/lib/features/` (each feature has pages + widgets).
- Shared UI components: `moonforge/lib/core/widgets/`.
- Layout and design system: `moonforge/lib/layout/`.
- State and providers: `moonforge/lib/core/providers/`.
- Service wiring / DI: `moonforge/lib/core/get_it/`.
- Data layer (local DB + repositories): `moonforge/lib/data/`.
- Generated code: `moonforge/lib/gen/`, `moonforge/lib/routes/app_router.gr.dart`.
- Localization: `moonforge/lib/l10n/`.
- Assets: `moonforge/assets/`.
- Supabase config and types: `supabase/`.
- PowerSync config: `powersync/` (notably `powersync/sync-rules.yaml`).

## Data Flow Quick Map

- PowerSync setup: `moonforge/lib/data/powersync.dart`.
- Supabase auth: `moonforge/lib/data/supabase.dart`.
- Backend connector: `moonforge/lib/data/connector.dart`.
- Drift DB and schema: `moonforge/lib/data/database.dart`,
  `moonforge/lib/data/models/powersync-schema.dart`.
- Generated table models: `moonforge/lib/data/models/database_classes.g.dart`.
- Views (scoped joins): `moonforge/lib/data/views.dart`.
- Repositories and providers: `moonforge/lib/data/stores/`.
- Scope helpers (watch by campaign/chapter/adventure/scene): `moonforge/lib/core/providers/ref_extensions.dart`.
- Data fetching guide: `docs/data_fetching.md`.

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

- follow [conventional commits](https://www.conventionalcommits.org/) guidelines
- The commit message should be structured as follows:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```
- The commit contains the following structural elements, to communicate intent to the consumers of your library:

    fix: a commit of the type fix patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
    feat: a commit of the type feat introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
    BREAKING CHANGE: a commit that has a footer BREAKING CHANGE:, or appends a ! after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
    types other than fix: and feat: are allowed, for example @commitlint/config-conventional (based on the Angular convention) recommends build:, chore:, ci:, docs:, style:, refactor:, perf:, test:, and others.
    footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.

- Additional types are not mandated by the Conventional Commits specification, and have no implicit effect in Semantic Versioning (unless they include a BREAKING CHANGE). A scope may be provided to a commit’s type, to provide additional contextual information and is contained within parenthesis, e.g., feat(parser): add ability to parse arrays.


## Configuration Tips

- Environment values are expected in `moonforge/.env` (listed in `pubspec.yaml` assets). Do not commit secrets.

## Additional Tips
- use dart mcp with tool pub_dev_search, if you are not sure about a package
- you can use dart mcp for generell commands like dart_fix, analyze_files and more

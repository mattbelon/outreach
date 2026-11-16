# Outreach

A Flutter application for managing outreach contacts offline. It lets users create, edit, search, filter, and delete leads, track their history, and import or export CSV data.

The current user interface is in English.

Spanish version: [README.es.md](README.es.md)

## Documentation

- [Architecture](docs/architecture.md)
- [Lead management specification](docs/specs/001-lead-management/spec.md)
- [Implementation plan](docs/specs/001-lead-management/plan.md)
- [Implementation tasks](docs/specs/001-lead-management/tasks.md)
- [Guide for AI coding agents](AGENTS.md)

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with Dart `^3.10.1`.
- A device, emulator, or desktop target configured for the chosen platform.
- For Android, Android Studio and the Android SDK; for Windows, Visual Studio C++ development tools.

Check the installation with:

```bash
flutter doctor
```

## Set up locally

Clone the repository and enter the project directory:

```bash
git clone <REPOSITORY_URL>
cd outreach_flutter
```

Install dependencies and list available targets:

```bash
flutter pub get
flutter devices
```

Run the application on a selected target:

```bash
flutter run
```

You can also specify a target directly:

```bash
flutter run -d windows
flutter run -d <DEVICE_ID>
```

## Common commands

```bash
# Run all tests
flutter test

# Analyze the codebase
flutter analyze

# Format Dart code
dart format lib test

# Generate Drift code after database changes
dart run build_runner build --delete-conflicting-outputs

# Keep the generator running during development
dart run build_runner watch --delete-conflicting-outputs

# Produce release builds for Windows or Android
flutter build windows
flutter build apk
```

## Project structure

```text
lib/
  main.dart                         Entry point and dependency setup.
  app/
    app.dart                         MaterialApp, theme, and shared repository.
    router/app_router.dart           List, creation, and edit routes.
    theme/app_theme.dart             Visual theme.
  core/database/
    app_database.dart                SQLite tables, migrations, and connection.
    app_database.g.dart              Generated code; do not edit manually.
  features/leads/
    domain/                          Models and repository contract.
    data/                            Drift and CSV read/write code.
    presentation/                    UI pages, Cubits, and UI states.
test/                                Domain, Cubit, and CSV import/export tests.
```

## Architecture

Each feature is split into three layers:

- `domain`: entities such as `Lead`, enums, and the `LeadsRepository` interface.
- `data`: the `DriftLeadsRepository` implementation and CSV services.
- `presentation`: widgets, states, and `flutter_bloc` Cubits.

`main.dart` creates `AppDatabase` and the repository. `OutreachApp` makes them available to screens, and `AppRouter` builds route-specific Cubits.

Data is stored locally in `outreach.sqlite` under the operating system's application support directory. There is no backend or credential configuration.

## Modify the application

### Change the UI or theme

- Update global colors, typography, and shared components in `lib/app/theme/app_theme.dart`.
- Update the list and CSV actions in `lib/features/leads/presentation/leads_list/leads_page.dart`.
- Update the form and history in `lib/features/leads/presentation/lead_form/` and `lead_history/`.
- Add or adjust routes in `lib/app/router/app_router.dart`.

While `flutter run` is active, saving applies hot reload to most widget changes. Restart the app after changing startup code, dependency setup, or the database.

### Add or change lead fields

1. Update entities and validation in `lib/features/leads/domain/lead.dart`.
2. Update the contract in `leads_repository.dart` and its implementation in `data/drift_leads_repository.dart`.
3. Update the `Leads` table, mappings, and migrations in `lib/core/database/app_database.dart`.
4. Increase `schemaVersion` and add a guarded migration in `onUpgrade`. Do not change previous migrations, because installed databases may already depend on them.
5. Regenerate `app_database.g.dart` with the `build_runner` command above.
6. Update the form, list, CSV code, and tests.

For a new nullable field, the migration will usually use `migrator.addColumn`. For a required field, provide a default value or data migration for existing installations.

### Add a feature

1. Create or extend entities in `domain`.
2. Add the required repository operations.
3. Implement data access in `data`.
4. Create a Cubit and state in `presentation`.
5. Wire the screen in `app_router.dart` and add tests under `test/`.

## CSV

The lead list can export all visible leads, a selection, or one lead. Import supports two modes:

- **Insert only**: creates a lead for every valid row.
- **Merge/update**: updates an existing lead when its email matches.

Before changing the CSV format, review and test `csv_leads_importer.dart`, `csv_leads_exporter.dart`, and their associated tests in `test/` together.

## Verify changes

```bash
dart format lib test
flutter analyze
flutter test
```

When changing a Drift table, also regenerate the code and verify the flow using an existing database, not only a clean installation.

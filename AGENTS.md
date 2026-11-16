# Agent Guide

## Project

Outreach is an offline-first Flutter application for managing leads. It uses Flutter, `flutter_bloc`, GoRouter, Drift, and SQLite.

## Before changing code

- Read the relevant feature specification under `docs/specs/`.
- Keep `domain`, `data`, and `presentation` responsibilities separate.
- Prefer a small change that preserves the existing repository contract and UI patterns.
- Do not edit `lib/core/database/app_database.g.dart`; regenerate it after changing Drift declarations.

## Database changes

- Update the domain model, repository contract, Drift repository, UI, CSV behavior, and tests together when a lead field changes.
- Increment `schemaVersion` and add a forward-only migration in `app_database.dart`.
- Do not rewrite an existing migration.
- Run `dart run build_runner build --delete-conflicting-outputs` after changing database declarations.

## Verification

Run these commands before considering a change complete:

```bash
dart format lib test
flutter analyze
flutter test
```

## Documentation

- Add or update a feature specification before implementing a user-visible capability.
- Keep `README.md` focused on people evaluating or running the project.
- Record architecture-wide decisions in `docs/architecture.md`.

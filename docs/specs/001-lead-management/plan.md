# Implementation Plan: Lead Management

**Status:** Implemented

## Technical approach

1. Model leads and their history in `features/leads/domain`.
2. Define the `LeadsRepository` contract so presentation code does not depend on Drift.
3. Persist leads and history in the `Leads` and `LeadHistory` Drift tables.
4. Expose reactive lists and history streams through `DriftLeadsRepository`.
5. Use a Cubit per presentation concern: lead list, form, and history.
6. Use GoRouter to create route-scoped Cubits for listing, creating, and editing.
7. Keep CSV parsing and serializing independent from widgets and database code.

## Data and migration rules

- SQLite is opened lazily and runs in a background isolate.
- Schema migrations are versioned in `AppDatabase.migration`.
- Indexes support status filtering, date ordering, email lookups, and history queries.
- A new schema change increments `schemaVersion`, adds a guarded upgrade step, regenerates Drift code, and is tested against existing data when practical.

## Validation strategy

- `LeadDraft` validates required company name and email format.
- CSV parsing returns row-level errors for invalid dates or invalid lead data.
- CSV files missing required headers fail before any import action.
- The repository rejects an invalid lead even if a caller bypasses the form.

## Verification

```bash
dart format lib test
flutter analyze
flutter test
```

The CSV importer/exporter, lead draft validation, and list Cubit each have focused tests under `test/`.

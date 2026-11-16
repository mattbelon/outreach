# Architecture

## Overview

Outreach is an offline-first Flutter application. Its only persistence mechanism is the local SQLite database managed by Drift; it does not call a backend service.

```text
Flutter UI -> Cubit -> LeadsRepository -> DriftLeadsRepository -> AppDatabase -> SQLite
```

The application starts in `lib/main.dart`, where `AppDatabase` and `DriftLeadsRepository` are created. `OutreachApp` exposes the repository with `RepositoryProvider`, while `AppRouter` creates the Cubit needed by each route.

## Modules

| Area | Responsibility |
| --- | --- |
| `app/` | Application shell, router, and visual theme. |
| `core/database/` | Drift table declarations, SQLite connection, indexes, and schema migrations. |
| `features/leads/domain/` | Lead models, lifecycle enums, and the `LeadsRepository` contract. |
| `features/leads/data/` | Drift repository plus CSV parsing and generation. |
| `features/leads/presentation/` | Flutter pages, Cubits, and immutable UI states. |
| `test/` | Unit tests for validation, Cubits, and CSV behavior. |

## Data model

`Leads` stores the company name, optional contact and website, email, lifecycle status, sent/replied timestamps, notes, and creation/update timestamps.

`LeadHistory` records actions associated with a lead. Actions include creation, updates, marking a lead as sent, imports, and deletion. Lead history is ordered newest first when displayed.

The SQLite file is named `outreach.sqlite` and is created in the platform's application-support directory.

## Routing

| Route | Purpose |
| --- | --- |
| `/leads` | Search, filter, select, import, export, and manage leads. |
| `/leads/new` | Create a lead. |
| `/leads/:id/edit` | Edit a lead and view its history. |

## Change boundaries

- UI behavior belongs in `presentation`; Cubits coordinate UI state and repository calls.
- Business data contracts belong in `domain`.
- SQLite and CSV details belong in `data` or `core/database`.
- Drift schema changes must be forward-only and accompanied by a version increment and generated code.

See [the lead management specification](specs/001-lead-management/spec.md) for product behavior and acceptance criteria.

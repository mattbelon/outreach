# Lead Management

**Status:** Implemented  
**Scope:** Local lead lifecycle, history, search/filtering, and CSV interchange.

## Problem

Outreach work is difficult to follow when contacts, delivery state, and notes live in disconnected spreadsheets. A user needs a local workspace to manage leads and move data in or out without relying on a service connection.

## Users and outcomes

### Manage a lead

As an outreach operator, I can create and edit a lead so that its company, email, contact details, status, dates, and notes are stored locally.

**Acceptance criteria**

- Company name and a syntactically valid email are required.
- A lead can have the statuses `pending`, `sent`, `replied`, `follow_up`, or `closed`.
- Saving a new lead creates a history entry.
- Updating a lead updates its timestamp and creates a history entry.
- Marking a lead as sent changes its status to `sent`; if no sent date exists, it records the current time.
- Deleting a lead requires confirmation.

### Find and prioritize leads

As an outreach operator, I can search and filter leads to focus on the relevant contacts.

**Acceptance criteria**

- Search matches company name or email without case sensitivity.
- Status filters can show all leads or one lifecycle status.
- Results are ordered by most recently updated.
- The UI presents a table on wide screens and cards on narrow screens.

### Preserve activity context

As an outreach operator, I can inspect the history of a lead to understand what happened to it.

**Acceptance criteria**

- Creation, updates, imports, and marking as sent create a timestamped activity record.
- A lead's history is displayed newest first on the edit view.

### Exchange leads as CSV

As an outreach operator, I can export leads and import a validated CSV file so that I can exchange data with other tools.

**Acceptance criteria**

- Export uses these columns in this order: `company_name`, `contact_name`, `email`, `website`, `status`, `sent_at`, `replied_at`, `notes`.
- Values containing commas, quotes, or line breaks are CSV-escaped.
- Import requires `company_name` and `email`; optional columns are recognized when present.
- Import supports quoted values and ISO-8601 dates.
- Invalid rows and empty rows are reported without preventing valid rows from being imported.
- The user can choose to always insert leads or merge/update by email.

## Non-goals

- User accounts, authentication, and cloud synchronization.
- Sending emails or integrating with an email provider.
- Automatic duplicate detection outside the explicit merge-by-email import mode.

## Constraints

- Data remains available without a network connection.
- Existing local databases must remain usable after schema changes.
- Every behavioral change must be covered by focused automated tests.

## Language preference

Users can choose English or Spanish from the lead-list app bar. The selector appears before the CSV export action, and the chosen language is restored when the application starts again.

## Presentation quality

The lead workspace presents a restrained B2B interface: a clear primary action, a concise pipeline summary derived from local data, readable filters, and responsive list/table layouts. Visual refinements must not change lead data, filtering, CSV behavior, or accessibility labels.

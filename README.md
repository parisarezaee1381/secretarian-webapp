# secretarian-webapp

A Persian-language (RTL) Flutter application for secretariat work: managing
**outgoing letters** (نامه صادره), **incoming letters** (نامه وارده) and
**contracts** (قرارداد) — with attachments, PDF handling, a filterable
document list, a dashboard, and local account authentication.

> **Scope note:** this README documents only the parts of the codebase that
> have been reviewed so far. Sections marked *To be documented* list code that
> exists but has not been reviewed yet; they are placeholders to be filled in
> later.

---

## Features (as implemented)

- **Three document kinds** — outgoing letters, incoming letters, contracts —
  modeled by a single sealed `Document` hierarchy with shared fields
  (letter number, Jalali date, subject, tags, organization, recipient,
  registration date, save-file, attachments, priority, send method,
  needs-follow-up).
- **Dashboard** grouping the three kinds, with open/delete actions
  (delete asks for confirmation and reports failures via snackbar).
- **Document list** — paginated table with a filter drawer, removable
  per-field filter chips, and navigation into the letter forms/views.
- **Filtering** — Jalali date range, keyword search, priority and send-method
  filters, with inline validation (see `lib/documents/filter.dart`).
- **Letter forms** (create + edit) for all three kinds, with tags,
  priority dropdown, optional PDF save, and success/error snackbars.
- **Document view pages** — read-only detail view per document kind on a
  shared responsive layout; «ویرایش» opens the matching form prefilled and
  the view refreshes in place when the form returns the saved document.
- **Local authentication** — registration, login, and password recovery
  (verify the stored "favorite color" answer, then set a new password);
  passwords stored as salted PBKDF2 hashes. No persisted session: every launch starts
  signed out (or at registration if no account exists yet).
- **Settings** — profile editing and password change.
- **Pending-letters badge** — a counter (`PendingLettersData.count`, a
  `ValueNotifier<int>`) kept in sync by the repository and surfaced by
  `PendingLettersButton`.
- **Persian-first UI** — whole tree is RTL, framework strings are localized to
  Persian, dates are Jalali (Shamsi), and text input auto-formats to
  `yyyy/MM/dd` via `SmartDateField`.

## Tech stack

| Concern | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.12.2`) |
| Local database | [Isar Community](https://github.com/isar/isar) (`isar_community`, `isar_community_flutter_libs`) + `build_runner` codegen (`.g.dart`) |
| Jalali dates | `shamsi_date` |
| Responsive sizing | `flutter_screenutil` (design size 1440×1024) |
| PDFs | `pdf`, `file_picker`, `file_selector` |
| Passwords | `crypto` (PBKDF2-HMAC-SHA-256, per-user salt) |
| Localization | `flutter_localizations`, locale pinned to `fa` |
| Lints | `flutter_lints` (stock rules) |
| Tests | `flutter_test`; `image` used only in tests to generate PNG fixtures |

The Dart package is named `flutter_application_1` (imports use
`package:flutter_application_1/...`), while the project folder is
`secretarian-webapp`. The analyzer excludes `build/`, `web/` and `windows/`
output directories.

## Getting started

```bash
flutter pub get

# Regenerate Isar collection code (*.g.dart) after schema changes
dart run build_runner build --delete-conflicting-outputs

flutter run -d chrome    # or: -d windows
```

Quality checks used during development:

```bash
flutter analyze --no-pub   # currently: no issues
flutter test                # currently: 55 tests passing
```

---

## Architecture

### Startup & error handling (`lib/main.dart`)

```
main()
 ├─ _installErrorHandlers()      chains FlutterError.onError (previous handler
 │                               kept) + PlatformDispatcher.onError → debugPrint
 ├─ unawaited(SessionController.instance.start())   DB work runs in background
 └─ runApp(SecretarianApp(controller: session))
```

Because `runApp` happens immediately, the first frame always appears; the
database work runs in the background and the gate screen (below) shows a
spinner until it finishes — or an error screen with a **retry** button
(«تلاش دوباره») if it fails or exceeds the 15-second startup timeout. Errors
that escape widgets or async gaps are logged instead of leaving a blank
window.

### The gate (`lib/core/session.dart`, `lib/app.dart`, `lib/core/startup.dart`)

Authentication state is a small state machine — `AppPhase`:
`starting → failed | noAccount | signedOut | signedIn` — owned by
`SessionController` (a `ChangeNotifier` singleton). `AppGate` renders a
`ListenableBuilder` over the controller and switches exhaustively on the
phase:

| Phase | Screen |
| --- | --- |
| `starting` | `StartupLoadingScreen` (spinner + «در حال بارگذاری اطلاعات…») |
| `failed` | `StartupErrorScreen` (error shown verbatim, retry button) |
| `noAccount` | `RegisterPage` |
| `signedOut` | `LoginPage` |
| `signedIn` | `Dashboard` |

Screens never navigate between these states; they call
`SessionScope.of(context).signIn()` / `.signOut()` and the gate re-renders.
`SessionController.start()` is memoized (retries and overlapping calls share
one run) and applies a 15s timeout, because a locked database file can hang
rather than throw.

`SessionController.forTesting(phase)` lets widget tests render any phase
without touching the database.

### App shell (`lib/app.dart`)

`SessionScope` → `ScreenUtilInit` (1440×1024, `minTextAdapt`) →
`MaterialApp` with:

- `theme: appTheme` (from `lib/core/theme.dart`),
- `locale: Locale('fa')` + `GlobalMaterialLocalizations.delegates` — this
  makes the whole tree RTL and translates Material's own strings,
- `onGenerateRoute: onGenerateAppRoute` (named routes, below),
- `home: AppGate(controller: session)`.

### Routing (`lib/core/routes.dart`)

Named routes exist only for **pushed** screens: `AppRoutes.forgotPassword`,
`AppRoutes.settings`, `AppRoutes.changePassword`. Sign-in, registration and
the dashboard are gate *phases*, not routes. `onGenerateAppRoute` returns
`null` for unknown names so Flutter reports them. Screens that carry a live
object (a document, profile fields) are opened through their constructor
instead of `RouteSettings.arguments`.

## Data layer

### Database

Isar is the local store; collection definitions and the `DatabaseService`
live under `lib/data/database/` *(details to be documented)*. Collections exist for
the three document kinds, the user table, and a letter counter.

### `DocumentRepository` (`lib/data/document_repository.dart`)

A singleton `ChangeNotifier` — the single owner of in-memory document state:

- `loadOutgoingFromDatabase` / `loadIncomingFromDatabase` /
  `loadContractsFromDatabase` — load into a temporary list, then swap
  (readers never observe a half-built list), then notify. `SessionController`
  runs them concurrently with `Future.wait`.
- `add*` / `update*` / `delete*` per document kind — the **database write
  happens before the in-memory list is mutated**, so a failed write never
  leaves the UI showing a phantom change. `update*`/`delete*` throw
  `StateError` for a missing id; `add*` rejects duplicate ids.
- `getLatest` returns the most recent documents (date-sorted).
- Getters are unmodifiable; fields are private.
- Shared `_apply*ToDb` / `*_fromDb` helpers keep the add and update paths from
  drifting apart.
- `_recalculatePendingCount` keeps `PendingLettersData.count` in sync.

Forms wrap repository calls in `try/catch` and report failures as generic
Persian snackbars — the exception itself stays in the debug log (see the
letter-forms section below).

### `UserRepository` (`lib/authentication/user_repository.dart`)

Singleton with `registerUser`, `login`, `recoveryAnswerExists`, `getUser`,
`updateUser`, `changePassword`, `verifyCurrentPassword`. Expected failures are
thrown as `UserFacingException` (carries a user-ready Persian message);
anything else escaping the repository is a bug — callers log it and show a
generic message instead. Passwords go through
`PasswordHasher` (PBKDF2-HMAC-SHA-256 with a per-user salt; legacy unsalted
SHA-256 hashes still verify). The "favorite color" the UI asks for is the
forgot-password recovery answer: it lives in the legacy-named `UserDb.email`
column, may never be blank, and `registerUser` checks for duplicate usernames
*inside* its write transaction because the username index is
unique + replace. `getUser()` reads the **first** user row — the app
implicitly assumes a single account per machine; the gate simply asks
"does any user exist?".

## Domain model (`lib/domain/documents.dart`)

- `sealed class Document` with four subtypes: `OutgoingLetterDocument`,
  `IncomingLetterDocument`, `ContractDocument`, `AttachmentDocument`.
- Value semantics: composed `==`/`hashCode`; `copyWith` uses an
  `_unsetValue` sentinel so `copyWith(field: null)` really assigns `null`.
- `AttachmentDocument` construction asserts (debug) that it carries either
  bytes or a path.
- Shared constants: `kNormalPriority`, `kUrgentPriority`, `kPriorityOptions`.
  **Priority and send method are deliberately plain strings, not enums** —
  enums would ripple through the Isar schema and require codegen/database
  migration for little gain.
- The `DocumentType` enum (outgoing/incoming/contract) and its Persian
  `label` getter also live here, so widget code (the document-type filter
  row, the letter-number generator, and the PDF export) imports the
  domain concept instead of defining it in the UI layer.
- `jalaliToComparable(String)` parses `yyyy/M/d`-style Jalali dates into a
  comparable integer (returns `null` for partial/invalid input); shared by the
  list filtering and the filter panel's date-range validation so both apply
  identical parsing.

## Filtering (`lib/documents/filter.dart`)

- `FilterValues` — an immutable value type (`==`/`hashCode` via `listEquals`;
  `List<String>` keywords defensively copied with `unmodifiable`).
- `FilterPanel` — a drawer with Jalali date range (`SmartDateField`),
  keyword search, priority and send-method dropdowns. The date range is
  validated inline above the apply button (a snackbar would be hidden behind
  the open drawer). Applying empty values is treated as "no filter".
- The document list keeps active filters as removable chips (one per
  `_FilterField`), and its `onApply` normalizes empty values to `null`.

## Letter forms (`lib/documents/`, `s_*`)

The three create/edit forms share one structure: controller-driven fields,
per-field errors validated on submit (shared `kRequiredFieldMessage`), a
55-character limit with an inline warning, tags chips, an attachments
panel, and a save-file toggle that can export a PDF.

- Submit is guarded against double-taps (`_isSubmitting` + `isLoading` on
  «ثبت») — a second tap during the letter-number/PDF step cannot save the
  document twice.
- On edit-save the form **pops back to the view that opened it** with the
  saved document; on create-save it pushes the view. The final document is
  derived with the model's `copyWith`, and canceling the PDF dialog during
  an edit keeps the previously saved PDF reference instead of dropping it
  (switching the option off explicitly clears it).
- «انصراف» asks for confirmation when anything was typed or attached;
  auto-filled fields (generated letter number, date pickers) don't count,
  so a pristine create form cancels instantly.
- `s_gharardad` and `s_sadere` switch to their stacked layout below
  `kWideLayoutBreakpoint` (`core/app_constants.dart`) — the same threshold the
  view pages use; `s_varede` adapts per-widget with `LayoutBuilder` and
  needs no global breakpoint.
- Controllers and error keys are named for the data they hold (e.g. the
  incoming form's `senderController` / `senderLetterNumberController` /
  `recipientController`).

## Document view pages (`lib/documents/`, `m_*` + `document_view.dart`)

Each form navigates to its matching read-only view after creating a
document; the three views (`m_sadere`, `m_varede`, `m_gharardad`) share
`DocumentViewScaffold`, `DocumentDetailRow` and `DocumentViewDivider`
(`documents/document_view.dart`):

- One responsive threshold (`kDocumentViewWideBreakpoint`, an alias of the
  forms' shared `kWideLayoutBreakpoint` = 800): detail
  rows are side-by-side (150px label + 548px value) at/above it and stacked
  below it — the previous per-page thresholds (600/700/900) let the fixed
  desktop row overflow between 700 and 777px. The content column is exactly
  `kDocumentViewRowWidth` wide; empty values render as `-`; dividers align
  under the value column.
- Optional rows appear only when they carry data (tags, follow-up block,
  saved file, attachment count).
- «چاپ» is displayed disabled — printing is not implemented anywhere in the
  app yet. «ویرایش» opens the matching form (`s_*`) with the document
  prefilled; on edit-save the form **pops back with the saved document**
  (create-save still pushes the view) and the view refreshes in place, so
  the navigation stack never grows and no stale data is shown.
- The contract view labels its number field «شماره قرارداد», matching the
  contract form (it used to say «شماره نامه» while binding `letterNumber`).

## Settings screens (`lib/settings/`)

- **Settings view** (`settingview.dart`) — shows username and recovery answer
  (long values ellipsize), edits the profile, and signs out behind a
  confirmation dialog (`SessionScope.signOut()` + `popUntil`; the gate swaps
  to login).
- **Edit profile** (`edit_setting.dart`) — seeded through its constructor from
  the view (constructor push is the documented convention for
  parameter-carrying screens, see `routes.dart`); saves via `updateUser` and
  reloads on return.
- **Change password** (`changepassword.dart`) — verifies the current password,
  requires the new one to differ from it and to meet `kMinPasswordLength`.
- All three share `AppPageScaffold` (header + padded scroll body + version
  label), guard against double submits with `_isSubmitting`/`isLoading`, and
  report failures by logging with `debugPrint` then showing either
  `UserFacingException.message` or a generic Persian message — never raw
  exception text.

## UI conventions

- **RTL & Persian everywhere** — via `locale: Locale('fa')`; no manual
  `Directionality` wrappers are needed anymore.
- **Estedad** is the bundled font family (variable font in `assets/`).
- **`AppColors`** (from `lib/core/theme.dart`) supplies shared colors such as
  `primary`, `error`, `mutedText`, `primaryContainer` instead of ad-hoc hex
  values.
- **Shared widgets** in `lib/widgets/`: `AppTextField` (text input),
  `SmartDateField` (Jalali date input that auto-formats to `yyyy/MM/dd`,
  optional label), `AppHeader`, `AppPageScaffold` (settings-style page chrome:
  header, padded scroll body, version label), a shared table widget, dropdowns,
  modals, `PendingLettersButton`, and more *(remaining widgets to be
  documented)*.
- **Context safety** — after every `await` that may outlive a widget, code
  checks `if (!mounted) return;` before using `BuildContext` (the analyzer's
  `use_build_context_synchronously` rule passes repo-wide). SnackBars use
  `ScaffoldMessenger.of(context)`.

## Testing

55 tests, all passing:

| File | Tests | Covers |
| --- | --- | --- |
| `test/documents_test.dart` | 16 | Model behavior: value equality, `copyWith` sentinel semantics, field mutation, the `AttachmentDocument` construction assert |
| `test/document_view_test.dart` | 4 | The shared view widgets: rows stack below the 800px breakpoint and sit side-by-side above it, empty values render as `-`, print is disabled, edit invokes its callback |
| `test/password_hasher_test.dart` | 5 | PBKDF2 derive/verify round-trip, fresh salt per derive, legacy unsalted SHA-256 hashes still verify, malformed hashes fail closed |
| `test/widget_test.dart` | 6 | The gate: every `AppPhase` renders the right screen (loading spinner, error + «تلاش دوباره», register, login, dashboard), and the gate follows live `signIn()`/`signOut()` |
| `test/scanner_pdf_test.dart` | 2 | `ScannerPdf.buildPdf` stitches scanned image pages into one multi-page PDF; rejects an empty page list with `ArgumentError` |
| `test/button_focus_test.dart` | 3 | Keyboard behavior of `CustomButton`/`HoverableContainer`: Tab/Shift+Tab traversal works (only space/enter key events are claimed, everything else bubbles up), space activates a focused button exactly once |
| `test/dropdown_menu_test.dart` | 4 | `AppDropdown`: Tab reaches *and passes* the trigger (no key swallowing), space opens the menu and Escape closes it, tapping an item reports it via `onChanged` and closes the menu, the open menu marks the current value as selected |
| `test/filter_buttons_test.dart` | 4 | `DocumentTypeFilterButtons` (controlled): toggling reports a fresh copy and never mutates an earlier report, toggling off works, the trio wraps on narrow widths instead of overflowing, selection is exposed to semantics as toggled |
| `test/header_test.dart` | 1 | The header's settings leading (a `HoverableContainer`): Tab reaches it and space activates it |
| `test/follow_up_modal_test.dart` | 2 | The follow-up dialog: confirming pops a typed `FollowUpResult` with the entered date/follower, an empty date is blocked inline, and the close button (spoken name «بستن») pops `null` |
| `test/notification_test.dart` | 2 | `PendingLettersButton`: no button while the count is zero, the label carries the live count and follows later changes |
| `test/pdf_generator_test.dart` | 1 | PDF export: the bundled Estedad font resolves via `rootBundle`, and `DocumentPdfGenerator` emits valid `%PDF` bytes for all three document types |
| `test/smart_date_field_test.dart` | 2 | Jalali date field: digits are re-slashed into `yyyy/MM/dd` (pasted separators normalized, eight-digit cap), and the caret stays beside the digit being edited instead of jumping to the end |
| `test/switch_button_test.dart` | 3 | `AppSwitch` keyboard contract: Tab traverses through the switch instead of trapping focus, space/enter toggles a focused switch exactly once per press, and a disabled switch is skipped by traversal |

## Project layout

```
lib/
  main.dart                 entry point: error handlers, session start, runApp
  app.dart                  app shell: theme, locale, routes, AppGate
  core/                     shared app infrastructure
    session.dart            SessionController, AppPhase, SessionScope
    startup.dart            startup loading / error (retry) screens
    routes.dart             named routes for pushed screens
    app_constants.dart      shared constants (version label, min password
                            length, required-field message, wide-layout
                            breakpoint, logo asset path)
    theme.dart              appTheme + AppColors                  [to be documented]
    pending_letters_data.dart
                            pending-letters ValueNotifier counter
  domain/
    documents.dart          sealed Document model + shared constants/helpers
  data/
    document_repository.dart
                            singleton document store (Isar + in-memory)
    database/               Isar collections + DatabaseService    [to be documented]
      collections/          the five collection schemas (+ .g.dart codegen)
  documents/                document screens: dashboard over the three kinds,
                            filterable paginated list, FilterValues +
                            FilterPanel drawer, letter forms (s_*, each
                            editable via initialDocument), view pages (m_*)
                            sharing document_view.dart
  authentication/           signup, login, forgetpassword, user_repository,
                            password_hasher
  settings/                 settings view, edit profile, change password
  widgets/                  shared widgets (table, text field, smart date
                            field, dropdowns, header, page scaffold, modal,
                            back icon, notification button, …)    [partially documented]
test/
  documents_test.dart       16 model tests
  document_view_test.dart   4 shared view-widget tests
  password_hasher_test.dart 5 password-hashing tests
  widget_test.dart          6 gate tests
  scanner_pdf_test.dart     2 PDF-stitching tests
  button_focus_test.dart    3 keyboard-focus tests
  dropdown_menu_test.dart   4 dropdown tests
  filter_buttons_test.dart  4 document-type filter tests
  header_test.dart          1 header keyboard test
  follow_up_modal_test.dart 2 follow-up dialog tests
  notification_test.dart    2 pending-letters button tests
  pdf_generator_test.dart   1 PDF export test
  smart_date_field_test.dart 2 date-field formatter tests
  switch_button_test.dart   3 switch key-handling tests
```

---

## To be documented

The following exist in the codebase but have **not been reviewed yet**; this
README will be extended once they are:

- **`lib/core/theme.dart` internals** — full palette, `appTheme` ThemeData details
  (only `appTheme` and the `AppColors` members `primary`, `error`,
  `mutedText`, `primaryContainer` are known so far).
- **`lib/data/database/`** — Isar collection schemas, `DatabaseService`
  initialization, letter counter, user collection.
- **`lib/widgets/` remaining widgets** — buttons, header, card, modal,
  dropdown menu, PDF viewer, file pickers, etc.
- **Attachments & scanning** — `lib/attachments/*` (attachment list, preview,
  error handling) and the scanner service.
- **PDF generation** — letter PDF export details (the Estedad font asset is
  referenced from the PDF path; `ScannerPdf.buildPdf` behavior is covered
  above via its tests).

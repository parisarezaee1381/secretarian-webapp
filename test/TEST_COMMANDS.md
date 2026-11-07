# Running the tests

All commands run from the project root:

```powershell
cd "C:\Users\Asus\Desktop\Flutter projects\secretarian app\secretarian-webapp"
```

`flutter test` also accepts `--plain-name <text>`, which is a **substring** match on
the test's full name (`group + test title`), so you rarely need the exact string.

## One command for everything

```powershell
flutter test                 # whole suite: 33 files, 246 tests, ~70s
flutter analyze              # static analysis (currently: no issues)
```

## The runner script

`test\run_tests.ps1` wraps the same commands and adds a per-file summary:

```powershell
.\test\run_tests.ps1                              # whole suite in one run
.\test\run_tests.ps1 -Analyze                     # flutter analyze
.\test\run_tests.ps1 -Each                        # every file in its own run + summary
.\test\run_tests.ps1 -Each -Filter 'test\data\*'  # same, only matching files
.\test\run_tests.ps1 -File data\user_repository_test.dart
.\test\run_tests.ps1 -File documents\document_list_test.dart -Name pagination
.\test\run_tests.ps1 -Name "jalaliToComparable"   # by test name, whole suite
.\test\run_tests.ps1 -IsarLibrary 'C:\path\to\isar.dll'   # if the DLL is not auto-found
```

If PowerShell blocks the script:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\test\run_tests.ps1 -Each
```

## By area

```powershell
flutter test test\data             # repository, numbering, accounts (needs IsarCore)
flutter test test\core             # SessionController startup/retry/phases (needs IsarCore)
flutter test test\authentication   # signup / login / recovery / change password
flutter test test\documents        # list, filters, dashboard, forms
flutter test test\settings         # settings + edit profile
flutter test test\widgets          # table, rows, PDF data, PDF export
flutter test test\attachments      # attachments panel, scanner channel, scan→PDF
flutter test test\domain           # Jalali parsing, labels, priorities
```

## Every file

| File | Tests | Command |
| --- | --- | --- |
| `test/attachments/attached_item_test.dart` | 5 | `flutter test test\attachments\attached_item_test.dart` |
| `test/attachments/attachments_panel_test.dart` | 12 | `flutter test test\attachments\attachments_panel_test.dart` |
| `test/attachments/scanner_service_test.dart` | 13 | `flutter test test\attachments\scanner_service_test.dart` |
| `test/authentication/auth_widgets_test.dart` | 14 | `flutter test test\authentication\auth_widgets_test.dart` |
| `test/button_focus_test.dart` | 3 | `flutter test test\button_focus_test.dart` |
| `test/core/session_controller_test.dart` | 9 | `flutter test test\core\session_controller_test.dart` |
| `test/data/document_repository_test.dart` | 20 | `flutter test test\data\document_repository_test.dart` |
| `test/data/letter_number_generator_test.dart` | 6 | `flutter test test\data\letter_number_generator_test.dart` |
| `test/data/user_repository_test.dart` | 15 | `flutter test test\data\user_repository_test.dart` |
| `test/document_view_test.dart` | 4 | `flutter test test\document_view_test.dart` |
| `test/documents/dashboard_test.dart` | 8 | `flutter test test\documents\dashboard_test.dart` |
| `test/documents/document_list_test.dart` | 13 | `flutter test test\documents\document_list_test.dart` |
| `test/documents/filter_panel_test.dart` | 11 | `flutter test test\documents\filter_panel_test.dart` |
| `test/documents/filter_values_test.dart` | 6 | `flutter test test\documents\filter_values_test.dart` |
| `test/documents/letter_forms_test.dart` | 13 | `flutter test test\documents\letter_forms_test.dart` |
| `test/documents_test.dart` | 16 | `flutter test test\documents_test.dart` |
| `test/domain/documents_extra_test.dart` | 9 | `flutter test test\domain\documents_extra_test.dart` |
| `test/dropdown_menu_test.dart` | 4 | `flutter test test\dropdown_menu_test.dart` |
| `test/filter_buttons_test.dart` | 4 | `flutter test test\filter_buttons_test.dart` |
| `test/follow_up_modal_test.dart` | 2 | `flutter test test\follow_up_modal_test.dart` |
| `test/header_test.dart` | 1 | `flutter test test\header_test.dart` |
| `test/notification_test.dart` | 2 | `flutter test test\notification_test.dart` |
| `test/password_hasher_test.dart` | 5 | `flutter test test\password_hasher_test.dart` |
| `test/pdf_generator_test.dart` | 1 | `flutter test test\pdf_generator_test.dart` |
| `test/scanner_pdf_test.dart` | 2 | `flutter test test\scanner_pdf_test.dart` |
| `test/settings/settings_test.dart` | 8 | `flutter test test\settings\settings_test.dart` |
| `test/smart_date_field_test.dart` | 2 | `flutter test test\smart_date_field_test.dart` |
| `test/switch_button_test.dart` | 3 | `flutter test test\switch_button_test.dart` |
| `test/widget_test.dart` | 6 | `flutter test test\widget_test.dart` |
| `test/widgets/document_table_test.dart` | 13 | `flutter test test\widgets\document_table_test.dart` |
| `test/widgets/pdf_document_data_test.dart` | 5 | `flutter test test\widgets\pdf_document_data_test.dart` |
| `test/widgets/pdf_export_test.dart` | 6 | `flutter test test\widgets\pdf_export_test.dart` |
| `test/widgets/table_rows_test.dart` | 5 | `flutter test test\widgets\table_rows_test.dart` |

## A single test or one group

```powershell
flutter test test\data\document_repository_test.dart --plain-name "duplicate id"
flutter test test\documents\document_list_test.dart --plain-name "pagination"
flutter test test\documents\letter_forms_test.dart --plain-name "follow-up"
flutter test test\attachments\attachments_panel_test.dart --plain-name "chooser"
flutter test --plain-name "jalaliToComparable"        # searches the whole suite
```

Add `--reporter expanded` to see each test as it starts:

```powershell
flutter test test\data\document_repository_test.dart --reporter expanded
```

## Bash / Git Bash

Same commands with forward slashes:

```bash
cd "/c/Users/Asus/Desktop/Flutter projects/secretarian app/secretarian-webapp"
flutter test
flutter test test/data/document_repository_test.dart --plain-name "duplicate id"
flutter test test/documents --reporter expanded
```

## Database-backed tests

`test/data/*` and `test/core/session_controller_test.dart` use a real Isar
database. `test/support/test_database.dart` finds IsarCore on disk
(`ISAR_CORE_LIBRARY`, the pub cache's `isar_flutter_libs`, or a
`flutter build windows` output). If none exists those tests are **skipped** with
a message rather than failing, and you can point at a copy explicitly:

```powershell
$env:ISAR_CORE_LIBRARY = 'C:\path\to\isar.dll'
flutter test test\data
```

```bash
ISAR_CORE_LIBRARY=/path/to/isar.dll flutter test test/data
```

## Not covered by the suite

Real scanner hardware (feeder/flatbed/jam), relaunch persistence, two app
instances on one database, OS file and save dialogs, Windows release and web
builds — see the manual checklist in the review.

import 'dart:io';

import 'package:isar_community/isar.dart';

import 'package:flutter_application_1/data/database/collections/contract_document_db.dart';
import 'package:flutter_application_1/data/database/collections/incoming_document_db.dart';
import 'package:flutter_application_1/data/database/collections/letter_counter.dart';
import 'package:flutter_application_1/data/database/collections/outgoing_document_db.dart';
import 'package:flutter_application_1/data/database/collections/user_db.dart';

/// Helpers for tests that need a real Isar database.
///
/// `flutter test` cannot download IsarCore (the test binding answers every
/// HTTP request with 400), so the native library is located on disk instead:
///
///   * `ISAR_CORE_LIBRARY` — explicit override, used on CI.
///   * the `isar_community_flutter_libs` copy in the pub cache (what a desktop
///     build links against).
///   * a `libisar.dll` left behind by `flutter build/run windows`.
///
/// Tests that need the database call [isarSkipReason] and skip with it when it
/// is non-null, so the suite still passes on a machine that has only ever run
/// `flutter test`.
String? get isarSkipReason {
  if (_cachedLibraryPath == null && !_searched) {
    _searched = true;
    _cachedLibraryPath = _findLibrary();
  }

  return _cachedLibraryPath == null
      ? 'IsarCore native library not found (set ISAR_CORE_LIBRARY, or run '
            '`flutter build windows` once so the DLL exists)'
      : null;
}

bool _searched = false;
String? _cachedLibraryPath;
bool _coreInitialized = false;

String get _libraryFileName {
  if (Platform.isWindows) return 'libisar.dll';
  if (Platform.isMacOS) return 'libisar.dylib';
  return 'libisar.so';
}

String? _findLibrary() {
  final override = Platform.environment['ISAR_CORE_LIBRARY'];
  if (override != null && File(override).existsSync()) return override;

  for (final root in _searchRoots()) {
    final found = _findIn(root);
    if (found != null) return found;
  }

  return null;
}

/// Pub-cache roots for every platform the tests might run on.
Iterable<Directory> _searchRoots() sync* {
  final localAppData = Platform.environment['LOCALAPPDATA'];
  final home = Platform.environment['HOME'];
  final appData = Platform.environment['APPDATA'];
  final userProfile = Platform.environment['USERPROFILE'];

  for (final base in [localAppData, home, appData, userProfile]) {
    if (base == null) continue;
    yield Directory('$base/Pub/Cache/hosted/pub.dev');
    yield Directory('$base/.pub-cache/hosted/pub.dev');
  }

  yield* _buildOutputRoots();
}

/// `build/windows/x64/runner/<config>/` is where a desktop build copies the
/// native libraries next to the executable.
Iterable<Directory> _buildOutputRoots() sync* {
  const candidates = [
    'build/windows/x64/runner',
    'build/linux/x64/debug/bundle',
    'build/linux/x64/release/bundle',
    'build/macos/Build/Products/Debug',
    'build/macos/Build/Products/Release',
  ];

  for (final candidate in candidates) {
    final directory = Directory(candidate);
    if (!directory.existsSync()) continue;

    yield directory;

    for (final child in directory.listSync().whereType<Directory>()) {
      yield child;
    }
  }
}

String? _findIn(Directory root) {
  if (!root.existsSync()) return null;

  try {
    for (final entry in root.listSync()) {
      if (entry is! Directory) continue;

      final name = entry.uri.pathSegments.lastWhere((s) => s.isNotEmpty);

      if (name.startsWith('isar_community_flutter_libs-')) {
        for (final candidate in [
          '${entry.path}/windows/$_libraryFileName',
          '${entry.path}/macos/$_libraryFileName',
          '${entry.path}/linux/$_libraryFileName',
        ]) {
          if (File(candidate).existsSync()) return candidate;
        }
      }

      final direct = '${entry.path}/$_libraryFileName';
      if (File(direct).existsSync()) return direct;

      final nested = _findIn(entry);
      if (nested != null) return nested;
    }
  } on FileSystemException {
    return null;
  }

  return null;
}

/// Every schema the app registers, in one place so a new collection does not
/// silently break the repository tests.
List<CollectionSchema<dynamic>> get testSchemas => <CollectionSchema<dynamic>>[
  UserDbSchema,
  LetterCounterSchema,
  OutgoingDocumentDbSchema,
  IncomingDocumentDbSchema,
  ContractDocumentDbSchema,
];

/// Opens a throwaway database in a fresh temp directory.
///
/// Call [isarSkipReason] first and skip the test when it is non-null.
Future<Isar> openTestIsar({String name = 'test'}) async {
  if (!_coreInitialized) {
    await _initializeCore();
    _coreInitialized = true;
  }

  final directory = await Directory.systemTemp.createTemp('secretarian_test_');

  return Isar.open(
    testSchemas,
    directory: directory.path,
    name: name,
    inspector: false,
  );
}

/// Loads the native library found by [isarSkipReason].
///
/// Isar resolves a bare library name through the loader's search path, which
/// includes the process working directory, so the lookup happens with the
/// directory holding the DLL as the current directory and is restored right
/// after. The handle is cached for the rest of the suite, and nothing is
/// downloaded (the test binding would answer that request with a 400).
Future<void> _initializeCore() async {
  final library = File(_cachedLibraryPath!);
  final previousDirectory = Directory.current;

  try {
    Directory.current = library.parent.path;
    await Isar.initializeIsarCore();
  } finally {
    Directory.current = previousDirectory;
  }
}

/// Empties every collection so each test starts from a known state without
/// paying to reopen the database.
Future<void> clearTestDatabase(Isar isar) async {
  await isar.writeTxn(() async {
    await isar.userDbs.clear();
    await isar.letterCounters.clear();
    await isar.outgoingDocumentDbs.clear();
    await isar.incomingDocumentDbs.clear();
    await isar.contractDocumentDbs.clear();
  });
}

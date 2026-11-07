/// Writes finished PDF bytes somewhere useful on the current platform.
///
/// Conditional export keeps `dart:io` out of web builds: IO targets write
/// the file at the given path, the web target triggers a browser download
/// named after the path's file part (browsers cannot pick a directory).
library;

export 'pdf_writer_io.dart'
    if (dart.library.js_interop) 'pdf_writer_web.dart';

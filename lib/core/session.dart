import 'package:flutter/widgets.dart';

import '../authentication/user_repository.dart';
import '../data/document_repository.dart';

/// Where the app is in its lifecycle.
enum AppPhase {
  /// Startup work is still running.
  starting,

  /// Startup failed; [SessionController.error] says why.
  failed,

  /// No account exists on this machine yet.
  noAccount,

  /// An account exists, but nobody has signed in yet.
  signedOut,

  /// A user is signed in.
  signedIn,
}

/// Owns startup work and the signed-in state for the whole app.
///
/// Screens never navigate to the login page or the dashboard themselves: they
/// call [signIn] / [signOut], and the gate in `app.dart` renders whichever
/// screen matches [phase]. That keeps "is anyone signed in?" in one place
/// instead of a bool decided once at launch.
class SessionController extends ChangeNotifier {
  SessionController({this.startupTimeout = const Duration(seconds: 15)})
    : _phase = AppPhase.starting;

  /// A controller parked in [phase], so widget tests can render the gate
  /// without touching the database.
  @visibleForTesting
  factory SessionController.forTesting(AppPhase phase) {
    final controller = SessionController();
    controller._phase = phase;
    return controller;
  }

  static final SessionController instance = SessionController();

  /// How long startup may take before the error screen is shown.
  ///
  /// A locked database file can hang instead of throwing, and a spinner with no
  /// escape is worse than a failure message.
  final Duration startupTimeout;

  AppPhase _phase;
  Object? _error;
  Future<void>? _running;

  AppPhase get phase => _phase;

  /// The failure behind [AppPhase.failed]; null in every other phase.
  Object? get error => _error;

  /// Loads the stored documents and decides whether an account exists.
  ///
  /// Safe to call again from the error screen: the loaders clear and refill
  /// their lists, a failed open is retried rather than reused, and overlapping
  /// calls share one run.
  Future<void> start() {
    return _running ??= _start().whenComplete(() {
      _running = null;
    });
  }

  Future<void> _start() async {
    _error = null;
    _setPhase(AppPhase.starting);

    try {
      // Independent reads, so they run together. `Future.wait` also collects
      // the other futures' errors, so a fast failure cannot leave an unhandled
      // exception behind.
      await Future.wait([
        DocumentRepository.instance.loadOutgoingFromDatabase(),
        DocumentRepository.instance.loadIncomingFromDatabase(),
        DocumentRepository.instance.loadContractsFromDatabase(),
      ]).timeout(startupTimeout);

      final user = await UserRepository.instance
          .getUser()
          .timeout(startupTimeout);

      _setPhase(user == null ? AppPhase.noAccount : AppPhase.signedOut);
    } catch (error) {
      _error = error;
      _setPhase(AppPhase.failed);
    }
  }

  /// Called after a successful sign in, registration or password reset.
  void signIn() => _setPhase(AppPhase.signedIn);

  /// Called when the user logs out.
  void signOut() => _setPhase(AppPhase.signedOut);

  void _setPhase(AppPhase phase) {
    if (_phase == phase) return;

    _phase = phase;
    notifyListeners();
  }
}

/// Provides the app's [SessionController] to the screens below it.
class SessionScope extends InheritedWidget {
  const SessionScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final SessionController controller;

  static SessionController of(BuildContext context) {
    final SessionScope? scope = context
        .dependOnInheritedWidgetOfExactType<SessionScope>();

    assert(scope != null, 'No SessionScope found above this widget.');

    return scope!.controller;
  }

  @override
  bool updateShouldNotify(SessionScope oldWidget) =>
      controller != oldWidget.controller;
}

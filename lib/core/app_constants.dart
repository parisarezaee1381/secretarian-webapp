// Constants shared by more than one screen.

/// The label shown at the bottom of the login and settings screens.
const String kAppVersionLabel = 'نسخه 1.0.0';

/// Shortest password the app accepts, wherever one is *created* —
/// registration, recovery and change-password. Login deliberately has no
/// minimum: an existing short password must still be able to sign in.
const int kMinPasswordLength = 6;

/// Inline message shown under a required text field left empty.
const String kRequiredFieldMessage = 'لطفا این فیلد را پر کنید';

/// Screen width at/above which the document screens (letter forms and
/// document views) use their wide, side-by-side layout; below it everything
/// stacks. One shared constant so a form and its view switch together.
const double kWideLayoutBreakpoint = 800;

/// Path to the app logo asset, shared by the header and the login card.
const String kLogoAssetPath = 'assets/images/logo.png';

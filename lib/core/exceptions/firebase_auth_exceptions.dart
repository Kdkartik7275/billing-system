class TFirebaseAuthException implements Exception {
  final String code;

  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      // ─────────────────────────────────────────────
      // LOGIN / AUTHENTICATION
      // ─────────────────────────────────────────────

      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password. Please check your credentials and try again.';

      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';

      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later.';

      case 'operation-not-allowed':
        return 'This sign-in method is currently disabled. Please contact support.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';

      // ─────────────────────────────────────────────
      // EMAIL
      // ─────────────────────────────────────────────

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'email-already-in-use':
        return 'This email address is already registered. Please use a different email.';

      case 'email-already-exists':
        return 'This email address already exists. Please use a different email.';

      // ─────────────────────────────────────────────
      // PASSWORD
      // ─────────────────────────────────────────────

      case 'weak-password':
        return 'Your password is too weak. Please choose a stronger password.';

      // ─────────────────────────────────────────────
      // ACCOUNT / CREDENTIAL
      // ─────────────────────────────────────────────

      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';

      case 'provider-already-linked':
        return 'This sign-in provider is already linked to your account.';

      case 'user-mismatch':
        return 'The credentials do not match the currently signed-in user.';

      // ─────────────────────────────────────────────
      // RE-AUTHENTICATION
      // ─────────────────────────────────────────────

      case 'requires-recent-login':
        return 'For security, please sign in again before performing this action.';

      case 'user-token-expired':
      case 'user-token-revoked':
      case 'user-token-mismatch':
        return 'Your session has expired. Please sign in again.';

      // ─────────────────────────────────────────────
      // VERIFICATION
      // ─────────────────────────────────────────────

      case 'invalid-verification-code':
        return 'The verification code is invalid. Please try again.';

      case 'invalid-verification-id':
        return 'The verification request is invalid. Please request a new code.';

      // ─────────────────────────────────────────────
      // ACTION CODE / EMAIL VERIFICATION
      // ─────────────────────────────────────────────

      case 'expired-action-code':
        return 'This verification link has expired. Please request a new one.';

      case 'invalid-action-code':
        return 'This verification link is invalid. Please request a new one.';

      case 'missing-action-code':
        return 'The verification code is missing. Please request a new link.';

      // ─────────────────────────────────────────────
      // QUOTA
      // ─────────────────────────────────────────────

      case 'quota-exceeded':
        return 'The request limit has been exceeded. Please try again later.';

      // ─────────────────────────────────────────────
      // APP / CONFIGURATION
      // ─────────────────────────────────────────────

      case 'app-deleted':
        return 'The Firebase application is no longer available.';

      case 'app-not-authorized':
        return 'This application is not authorized to use Firebase Authentication.';

      case 'invalid-api-key':
        return 'Firebase configuration is invalid. Please contact support.';

      case 'invalid-app-credential':
        return 'The application credentials are invalid. Please contact support.';

      case 'missing-app-credential':
        return 'The application credentials are missing. Please contact support.';

      case 'auth-domain-config-required':
        return 'Firebase Authentication domain configuration is required.';

      // ─────────────────────────────────────────────
      // WEB
      // ─────────────────────────────────────────────

      case 'web-storage-unsupported':
        return 'Browser storage is unavailable. Please enable browser storage and try again.';

      // ─────────────────────────────────────────────
      // KEYCHAIN / PLATFORM
      // ─────────────────────────────────────────────

      case 'keychain-error':
        return 'A secure storage error occurred. Please try again.';

      case 'invalid-cordova-configuration':
        return 'The application configuration is invalid.';

      // ─────────────────────────────────────────────
      // EMAIL TEMPLATE / EMAIL SENDING
      // ─────────────────────────────────────────────

      case 'invalid-message-payload':
        return 'The email message configuration is invalid.';

      case 'invalid-sender':
        return 'The email sender configuration is invalid.';

      case 'invalid-recipient-email':
        return 'The recipient email address is invalid.';

      case 'missing-iframe-start':
        return 'The email template configuration is invalid.';

      case 'missing-iframe-end':
        return 'The email template configuration is invalid.';

      case 'missing-iframe-src':
        return 'The email template configuration is invalid.';

      // ─────────────────────────────────────────────
      // SESSION
      // ─────────────────────────────────────────────

      case 'session-cookie-expired':
        return 'Your session has expired. Please sign in again.';

      // ─────────────────────────────────────────────
      // USER MANAGEMENT
      // ─────────────────────────────────────────────

      case 'uid-already-exists':
        return 'This user ID is already in use.';

      // ─────────────────────────────────────────────
      // INTERNAL
      // ─────────────────────────────────────────────

      case 'internal-error':
        return 'An internal authentication error occurred. Please try again later.';

      // ─────────────────────────────────────────────
      // FALLBACK
      // ─────────────────────────────────────────────

      default:
        return 'Unable to sign in. Please check your details and try again.';
    }
  }

  @override
  String toString() => message;
}

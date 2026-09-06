class TFirebaseException implements Exception {
  final String code;

  TFirebaseException(this.code);

  String get message {
    switch (code) {
      // ─────────────────────────────────────────────
      // GENERAL FIREBASE
      // ─────────────────────────────────────────────

      case 'unknown':
        return 'An unknown Firebase error occurred. Please try again.';

      case 'internal-error':
        return 'An internal Firebase error occurred. Please try again later.';

      case 'network-request-failed':
        return 'A network error occurred. Please check your internet connection and try again.';

      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';

      case 'quota-exceeded':
        return 'The request limit has been exceeded. Please try again later.';

      case 'resource-exhausted':
        return 'Quota exceeded. Please try again later.';

      case 'deadline-exceeded':
        return 'The operation took too long. Please try again.';

      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';

      case 'cancelled':
        return 'The operation was cancelled. Please try again.';

      // ─────────────────────────────────────────────
      // FIRESTORE / DATABASE
      // ─────────────────────────────────────────────

      case 'permission-denied':
        return 'You do not have permission to perform this action.';

      case 'not-found':
        return 'The requested document or resource was not found.';

      case 'already-exists':
        return 'The document you are trying to create already exists.';

      case 'unauthenticated':
        return 'You must be signed in to perform this action.';

      case 'failed-precondition':
        return 'The operation failed due to a precondition not being met.';

      case 'out-of-range':
        return 'The operation specified an invalid range.';

      case 'unimplemented':
        return 'This operation is not implemented.';

      case 'data-loss':
        return 'Unrecoverable data loss or corruption occurred.';

      // ─────────────────────────────────────────────
      // AUTHENTICATION
      // ─────────────────────────────────────────────

      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials. Please check your email and password.';

      case 'invalid-custom-token':
        return 'The custom authentication token is invalid. Please try again.';

      case 'custom-token-mismatch':
        return 'The custom token belongs to a different Firebase project.';

      case 'user-disabled':
        return 'This user account has been disabled. Please contact support.';

      case 'user-not-found':
        return 'No account was found with these credentials.';

      case 'invalid-email':
        return 'The email address is invalid. Please enter a valid email address.';

      case 'email-already-in-use':
        return 'This email address is already registered. Please use a different email.';

      case 'email-already-exists':
        return 'This email address is already registered. Please use a different email.';

      case 'wrong-password':
        return 'Invalid login credentials. Please check your email and password.';

      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';

      case 'too-many-requests':
        return 'Too many attempts have been made. Please try again later.';

      // ─────────────────────────────────────────────
      // CREDENTIALS / PROVIDERS
      // ─────────────────────────────────────────────

      case 'provider-already-linked':
        return 'This sign-in provider is already linked to your account.';

      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';

      case 'user-mismatch':
        return 'The credentials do not match the currently signed-in user.';

      // ─────────────────────────────────────────────
      // VERIFICATION
      // ─────────────────────────────────────────────

      case 'invalid-verification-code':
        return 'The verification code is invalid. Please try again.';

      case 'invalid-verification-id':
        return 'The verification request is invalid. Please request a new verification code.';

      case 'captcha-check-failed':
        return 'The security verification failed. Please try again.';

      // ─────────────────────────────────────────────
      // ACTION CODE / EMAIL VERIFICATION
      // ─────────────────────────────────────────────

      case 'expired-action-code':
        return 'This verification link has expired. Please request a new one.';

      case 'invalid-action-code':
        return 'This verification link is invalid. Please request a new one.';

      case 'missing-action-code':
        return 'The verification action code is missing. Please request a new link.';

      // ─────────────────────────────────────────────
      // RE-AUTHENTICATION / SESSION
      // ─────────────────────────────────────────────

      case 'requires-recent-login':
        return 'For security, please sign in again before performing this action.';

      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';

      case 'user-token-revoked':
        return 'Your session has been revoked. Please sign in again.';

      case 'user-token-mismatch':
        return 'Your authentication session is invalid. Please sign in again.';

      case 'session-cookie-expired':
        return 'Your session has expired. Please sign in again.';

      // ─────────────────────────────────────────────
      // APP / FIREBASE CONFIGURATION
      // ─────────────────────────────────────────────

      case 'app-not-authorized':
        return 'This application is not authorized to use Firebase Authentication.';

      case 'app-deleted':
        return 'The Firebase application is no longer available.';

      case 'invalid-api-key':
        return 'The Firebase API key is invalid. Please contact support.';

      case 'invalid-app-credential':
        return 'The application credentials are invalid. Please contact support.';

      case 'missing-app-credential':
        return 'The application credentials are missing. Please contact support.';

      case 'auth-domain-config-required':
        return 'The Firebase authentication domain is not configured correctly.';

      case 'invalid-cordova-configuration':
        return 'The application configuration is invalid. Please contact support.';

      // ─────────────────────────────────────────────
      // WEB
      // ─────────────────────────────────────────────

      case 'web-storage-unsupported':
        return 'Browser storage is unavailable or disabled. Please enable it and try again.';

      // ─────────────────────────────────────────────
      // KEYCHAIN / PLATFORM
      // ─────────────────────────────────────────────

      case 'keychain-error':
        return 'A secure storage error occurred. Please try again.';

      // ─────────────────────────────────────────────
      // EMAIL / TEMPLATE
      // ─────────────────────────────────────────────

      case 'invalid-message-payload':
        return 'The email message configuration is invalid.';

      case 'invalid-sender':
        return 'The email sender configuration is invalid.';

      case 'invalid-recipient-email':
        return 'The recipient email address is invalid.';

      case 'missing-iframe-start':
      case 'missing-iframe-end':
      case 'missing-iframe-src':
        return 'The email template configuration is invalid.';

      // ─────────────────────────────────────────────
      // USER MANAGEMENT
      // ─────────────────────────────────────────────

      case 'uid-already-exists':
        return 'This user ID is already in use by another account.';

      // ─────────────────────────────────────────────
      // FALLBACK
      // ─────────────────────────────────────────────

      default:
        return 'An unexpected Firebase error occurred. Please try again.';
    }
  }

  @override
  String toString() => message;
}

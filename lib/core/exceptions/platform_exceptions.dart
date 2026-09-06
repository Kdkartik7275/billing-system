class TPlatformException implements Exception {
  final String code;

  const TPlatformException(this.code);

  String get message {
    switch (code) {
      // --- Credentials ---
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'invalid-credential':
        return 'Invalid login credentials. Please double-check your information.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'invalid-password':
        return 'Incorrect password. Please try again.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';

      // --- Registration ---
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'uid-already-exists':
        return 'The provided user ID is already in use by another user.';
      case 'weak-password':
        return 'The password provided is too weak. Please choose a stronger one.';

      // --- Phone auth ---
      case 'invalid-phone-number':
        return 'The provided phone number is invalid.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please enter a valid code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new verification code.';
      case 'missing-verification-code':
        return 'Please enter the verification code.';
      case 'missing-verification-id':
        return 'Verification ID is missing. Please request a new code.';
      case 'session-expired':
        return 'The verification code has expired. Please request a new one.';

      // --- Configuration / provider ---
      case 'operation-not-allowed':
        return 'The sign-in provider is disabled for your Firebase project.';
      case 'invalid-argument':
        return 'Invalid argument provided to the authentication method.';
      case 'invalid-api-key':
        return 'Invalid API key. Please contact support.';
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';

      // --- Session / token ---
      case 'session-cookie-expired':
        return 'The Firebase session cookie has expired. Please sign in again.';
      case 'user-token-expired':
      case 'user-mismatch':
        return 'Your session has expired. Please sign in again.';
      case 'requires-recent-login':
        return 'This action requires recent authentication. Please sign in again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different account.';

      // --- Network / rate limiting ---
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network request failed. Please check your internet connection.';
      case 'quota-exceeded':
        return 'Quota exceeded. Please try again later.';
      case 'timeout':
        return 'The operation timed out. Please try again.';

      // --- Generic / platform-level ---
      case 'sign_in_failed':
      case 'sign_in_canceled':
        return 'Sign-in failed or was canceled. Please try again.';
      case 'internal-error':
        return 'Internal error. Please try again later.';
      case 'popup-closed-by-user':
        return 'The sign-in popup was closed before completing. Please try again.';
      case 'web-context-canceled':
        return 'The sign-in flow was canceled. Please try again.';

      // Add more cases as needed...
      default:
        return 'An unexpected platform error occurred. Please try again.';
    }
  }
}

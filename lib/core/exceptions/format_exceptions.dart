class TFirebaseException implements Exception {
  final String message;

  const TFirebaseException([
    this.message = 'An unexpected Firebase error occurred. Please try again.',
  ]);

  factory TFirebaseException.fromMessage(String message) {
    return TFirebaseException(message);
  }

  String get formattedMessage => message;

  factory TFirebaseException.fromCode(String code) {
    switch (code) {
      // --- Auth: sign-in / credentials ---
      case 'invalid-email':
        return const TFirebaseException(
          'The email address is badly formatted.',
        );
      case 'user-disabled':
        return const TFirebaseException(
          'This user has been disabled. Please contact support.',
        );
      case 'user-not-found':
        return const TFirebaseException(
          'No user found with this email address.',
        );
      case 'wrong-password':
        return const TFirebaseException(
          'Incorrect password. Please try again.',
        );
      case 'invalid-credential':
        return const TFirebaseException(
          'The credentials provided are invalid or have expired.',
        );
      case 'account-exists-with-different-credential':
        return const TFirebaseException(
          'An account already exists with a different sign-in method for this email.',
        );
      case 'invalid-verification-code':
        return const TFirebaseException(
          'The verification code is invalid. Please try again.',
        );
      case 'invalid-verification-id':
        return const TFirebaseException(
          'The verification ID is invalid. Please try again.',
        );

      // --- Auth: registration ---
      case 'email-already-in-use':
        return const TFirebaseException(
          'An account already exists with this email address.',
        );
      case 'operation-not-allowed':
        return const TFirebaseException(
          'This sign-in method is not enabled. Please contact support.',
        );
      case 'weak-password':
        return const TFirebaseException(
          'The password provided is too weak. Please choose a stronger one.',
        );

      // --- Auth: session / token ---
      case 'user-token-expired':
        return const TFirebaseException(
          'Your session has expired. Please log in again.',
        );
      case 'user-mismatch':
        return const TFirebaseException(
          'The provided credentials do not match the current user.',
        );
      case 'requires-recent-login':
        return const TFirebaseException(
          'This operation is sensitive and requires recent authentication. Please log in again.',
        );
      case 'credential-already-in-use':
        return const TFirebaseException(
          'This credential is already associated with a different user account.',
        );

      // --- Auth: rate limiting / network ---
      case 'too-many-requests':
        return const TFirebaseException(
          'Too many attempts. Please wait a while before trying again.',
        );
      case 'network-request-failed':
        return const TFirebaseException(
          'A network error occurred. Please check your connection and try again.',
        );

      // --- Firestore / permissions ---
      case 'permission-denied':
        return const TFirebaseException(
          'You do not have permission to perform this action.',
        );
      case 'unavailable':
        return const TFirebaseException(
          'The service is currently unavailable. Please try again later.',
        );
      case 'not-found':
        return const TFirebaseException(
          'The requested document or resource was not found.',
        );
      case 'already-exists':
        return const TFirebaseException(
          'The document you are trying to create already exists.',
        );
      case 'cancelled':
        return const TFirebaseException(
          'The operation was cancelled. Please try again.',
        );
      case 'deadline-exceeded':
        return const TFirebaseException(
          'The operation took too long to complete. Please try again.',
        );
      case 'resource-exhausted':
        return const TFirebaseException(
          'Quota exceeded. Please try again later.',
        );
      case 'unauthenticated':
        return const TFirebaseException(
          'You must be signed in to perform this action.',
        );

      // Add more cases as needed...
      default:
        return const TFirebaseException();
    }
  }
}

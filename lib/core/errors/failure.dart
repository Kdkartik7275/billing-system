abstract class Failure {
  final String message;
  final int statusCode;

  Failure({required this.message, required this.statusCode});
}

class FirebaseFailure extends Failure {
  FirebaseFailure({required super.message, super.statusCode = 400});
}

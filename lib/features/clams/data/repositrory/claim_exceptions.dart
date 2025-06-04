// claim_exceptions.dart

class ClaimValidationException implements Exception {
  final String message;
  ClaimValidationException(this.message);

  @override
  String toString() => "ClaimValidationException: $message";
}

class ClaimSubmissionException implements Exception {
  final String message;
  ClaimSubmissionException(this.message);

  @override
  String toString() => "ClaimSubmissionException: $message";
}

import '../../data/models/claim_model.dart';

abstract class ClaimHistoryState {}

class ClaimHistoryInitial extends ClaimHistoryState {}

class ClaimHistoryLoading extends ClaimHistoryState {}

class ClaimHistoryLoaded extends ClaimHistoryState {
  final List<ClaimModel> claims;
  final List<ClaimModel> completedClaims;
  final List<ClaimModel> processingClaims;

  ClaimHistoryLoaded({
    required this.claims,
    required this.completedClaims,
    required this.processingClaims,
  });
}

class ClaimHistoryError extends ClaimHistoryState {
  final String message;
  ClaimHistoryError({required this.message});
}
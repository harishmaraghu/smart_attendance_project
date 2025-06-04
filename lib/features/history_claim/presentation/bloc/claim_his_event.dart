abstract class ClaimHistoryEvent {}

class LoadClaimsEvent extends ClaimHistoryEvent {
  final String userId;
  LoadClaimsEvent({required this.userId});
}

class RefreshClaimsEvent extends ClaimHistoryEvent {
  final String userId;
  RefreshClaimsEvent({required this.userId});
}
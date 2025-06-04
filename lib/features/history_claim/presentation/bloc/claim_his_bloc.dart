


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/history_claim/data/repositories/claim_repository.dart';

import 'claim_his_event.dart';
import 'claim_his_state.dart';
// import 'package:smart_attendance_project/features/history_claim/data/repositories/claim_repostitory' ;

class ClaimHistoryBloc extends Bloc<ClaimHistoryEvent, ClaimHistoryState> {
  final ClaimHisRepository repository;

  ClaimHistoryBloc({required this.repository}) : super(ClaimHistoryInitial()) {
    on<LoadClaimsEvent>(_onLoadClaims);
    on<RefreshClaimsEvent>(_onRefreshClaims);
  }

  Future<void> _onLoadClaims(LoadClaimsEvent event, Emitter<ClaimHistoryState> emit) async {
    emit(ClaimHistoryLoading());
    try {
      final claims = await repository.getClaims(event.userId);

      // Separate claims by status
      final completedClaims = claims.where((claim) =>
      claim.status.toLowerCase() == 'settled').toList();
      final processingClaims = claims.where((claim) =>
      claim.status.toLowerCase() != 'settled').toList();

      // Sort by date (newest first)
      claims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      completedClaims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      processingClaims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      emit(ClaimHistoryLoaded(
        claims: claims,
        completedClaims: completedClaims,
        processingClaims: processingClaims,
      ));
    } catch (e) {
      emit(ClaimHistoryError(message: e.toString()));
    }
  }

  Future<void> _onRefreshClaims(RefreshClaimsEvent event, Emitter<ClaimHistoryState> emit) async {
    try {
      final claims = await repository.getClaims(event.userId);

      final completedClaims = claims.where((claim) =>
      claim.status.toLowerCase() == 'settled').toList();
      final processingClaims = claims.where((claim) =>
      claim.status.toLowerCase() != 'settled').toList();

      claims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      completedClaims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      processingClaims.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

      emit(ClaimHistoryLoaded(
        claims: claims,
        completedClaims: completedClaims,
        processingClaims: processingClaims,
      ));
    } catch (e) {
      emit(ClaimHistoryError(message: e.toString()));
    }
  }
}
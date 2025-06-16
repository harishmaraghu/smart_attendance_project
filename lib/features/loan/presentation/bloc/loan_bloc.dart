// loan_bloc.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';
import 'package:smart_attendance_project/features/loan/data/repositories/loan_history_repository.dart';
import 'package:smart_attendance_project/features/loan/domain/loan_repo_impl.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_event.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(LoanInitial()) {
    on<SubmitLoanForm>(_onSubmitLoanForm);
  }

  Future<void> _onSubmitLoanForm(
      SubmitLoanForm event,
      Emitter<LoanState> emit,
      ) async {
    emit(LoanLoading());

    try {
      final success = await LoanService.applyLoan(
        userId: event.userId,
        userName: event.userName,
        paymentClaimType: event.paymentClaimType,
        amount: event.amount,
        duration: event.duration,
        emiAmount: event.emiAmount,
      );

      if (success) {
        emit(LoanSuccess());
      } else {
        emit(LoanFailure("Failed to submit loan application"));
      }
    } catch (e) {
      emit(LoanFailure("Error: ${e.toString()}"));
    }
  }
}



//loan history

class LoanHistoryBloc extends Bloc<LoanHistoryEvent, LoanHistoryState> {
  final LoanHistoryRepository _repository;

  LoanHistoryBloc({required LoanHistoryRepository repository})
      : _repository = repository,
        super(LoanHistoryInitial()) {
    on<LoadLoanHistory>(_onLoadLoanHistory);
    on<RefreshLoanHistory>(_onRefreshLoanHistory);
    on<FilterLoanHistory>(_onFilterLoanHistory);
  }

  Future<void> _onLoadLoanHistory(
      LoadLoanHistory event,
      Emitter<LoanHistoryState> emit,
      ) async {
    emit(LoanHistoryLoading());
    await _fetchLoanHistory(event.userId, emit);
  }

  Future<void> _onRefreshLoanHistory(
      RefreshLoanHistory event,
      Emitter<LoanHistoryState> emit,
      ) async {
    await _fetchLoanHistory(event.userId, emit);
  }

  void _onFilterLoanHistory(
      FilterLoanHistory event,
      Emitter<LoanHistoryState> emit,
      ) {
    if (state is LoanHistoryLoaded) {
      final currentState = state as LoanHistoryLoaded;
      final filteredItems = filterItemsByStatus(currentState.allItems, event.status);

      emit(LoanHistoryLoaded(
        allItems: currentState.allItems,
        filteredItems: filteredItems,
        processingCount: currentState.processingCount,
        successfulCount: currentState.successfulCount,
        rejectedCount: currentState.rejectedCount,
        currentFilter: event.status,
      ));
    }
  }

  List<LoanHistoryItem> filterItemsByStatus(List<LoanHistoryItem> items, FilterStatus filter) {
    switch (filter) {
      case FilterStatus.processing:
        return items.where((item) => item.isProcessing).toList();
      case FilterStatus.successful:
        return items.where((item) => item.isSuccessful).toList();
      case FilterStatus.rejected:
        return items.where((item) => item.isRejected).toList();
      case FilterStatus.all:
      default:
        return items;
    }
  }

  Future<void> _fetchLoanHistory(
      String userId,
      Emitter<LoanHistoryState> emit,
      ) async {
    try {
      final response = await _repository.getLoanHistory(userId);

      // UPDATED: Calculate counts based on the new status logic
      int processingCount = 0;
      int successfulCount = 0;
      int rejectedCount = 0;

      for (var item in response.data) {
        if (item.isSuccessful) {
          successfulCount++;
        } else if (item.isRejected) {
          rejectedCount++;
        } else {
          processingCount++;
        }
      }

      emit(LoanHistoryLoaded(
        allItems: response.data,
        filteredItems: response.data,
        processingCount: processingCount,
        successfulCount: successfulCount,
        rejectedCount: rejectedCount,
        currentFilter: FilterStatus.all,
      ));
    } catch (e) {
      emit(LoanHistoryError(e.toString()));
    }
  }
}

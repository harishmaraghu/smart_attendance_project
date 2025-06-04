import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/datasours/leave_dashboard_repository.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/models/leavedashboard_model.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_event.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_state.dart';



class LeaveDashboardBloc extends Bloc<LeaveDashboardEvent, LeaveDashboardState> {
  final LeaveDashboardRepository _repository;

  LeaveDashboardBloc({required LeaveDashboardRepository repository})
      : _repository = repository,
        super(LeaveDashboardInitial()) {
    on<LoadLeaveDashboard>(_onLoadLeaveDashboard);
    on<RefreshLeaveDashboard>(_onRefreshLeaveDashboard);
  }

  Future<void> _onLoadLeaveDashboard(
      LoadLeaveDashboard event,
      Emitter<LeaveDashboardState> emit,
      ) async {
    emit(LeaveDashboardLoading());
    try {
      final leaveDashboard = await _repository.getLeaveDashboard(
        userId: event.userId,
        name: event.name,
      );
      emit(LeaveDashboardLoaded(leaveDashboard: leaveDashboard));
    } catch (e) {
      emit(LeaveDashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshLeaveDashboard(
      RefreshLeaveDashboard event,
      Emitter<LeaveDashboardState> emit,
      ) async {
    try {
      final leaveDashboard = await _repository.getLeaveDashboard(
        userId: event.userId,
        name: event.name,
      );
      emit(LeaveDashboardLoaded(leaveDashboard: leaveDashboard));
    } catch (e) {
      emit(LeaveDashboardError(message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/payment/payslip/data/services/payslipapiservice.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_event.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  final PayslipApiService _apiService;

  PayslipBloc(this._apiService) : super(PayslipInitial()) {
    on<LoadPayslip>(_onLoadPayslip);
    on<RefreshPayslip>(_onRefreshPayslip);
  }

  Future<void> _onLoadPayslip(
      LoadPayslip event,
      Emitter<PayslipState> emit,
      ) async {
    emit(PayslipLoading());
    try {
      final payslip = await _apiService.getPayslip(
        userId: event.userId,
        username: event.username,
        date: event.date,
      );
      emit(PayslipLoaded(payslip));
    } catch (e) {
      emit(PayslipError(e.toString()));
    }
  }

  Future<void> _onRefreshPayslip(
      RefreshPayslip event,
      Emitter<PayslipState> emit,
      ) async {
    try {
      final payslip = await _apiService.getPayslip(
        userId: event.userId,
        username: event.username,
        date: event.date,
      );
      emit(PayslipLoaded(payslip));
    } catch (e) {
      emit(PayslipError(e.toString()));
    }
  }
}

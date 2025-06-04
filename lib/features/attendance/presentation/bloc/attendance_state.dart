import '../../data/models/attendance_record_model.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceRecord> records;

  AttendanceLoaded(this.records);
}

class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);
}

//


// // user_bloc_state.dart
abstract class UserState {}

class UserInitial extends UserState {}

class UsernameLoaded extends UserState {
  final String username;
  final String Userid;

  UsernameLoaded(this.username,this.Userid);
}






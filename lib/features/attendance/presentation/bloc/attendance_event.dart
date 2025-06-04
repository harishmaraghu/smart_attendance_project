abstract class AttendanceEvent {}

class FetchAttendance extends AttendanceEvent {
  final String username;
  final String date;

  FetchAttendance(this.username, this.date);
}





// attendances
// user_bloc_event.dart
abstract class UserEvent {}

class LoadUsernameEvent extends UserEvent {}


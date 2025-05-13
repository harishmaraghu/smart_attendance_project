abstract class AttendanceEvent {}

class FetchAttendance extends AttendanceEvent {
  final String username;
  final String date;

  FetchAttendance(this.username, this.date);
}

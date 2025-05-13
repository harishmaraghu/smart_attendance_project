class CheckInRequestModel {
  final String name;
  final String date;
  final String time;
  final String timeType;
  final String imageKey;
  final double latitude;
  final double longitude;

  CheckInRequestModel({
    required this.name,
    required this.date,
    required this.time,
    required this.timeType,
    required this.imageKey,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "date": date,
      "time": time,
      "timeType": timeType,
      "imageKey": imageKey,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

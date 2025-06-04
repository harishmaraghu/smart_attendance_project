class CheckInRequestModel {
  final String name;
  final String date;
  final String time;
  final String timeType;
  final String imageKey;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  CheckInRequestModel({
    required this.name,
    required this.date,
    required this.time,
    required this.timeType,
    required this.imageKey,
    this.imageUrl,

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
      'imageUrl': imageUrl,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory CheckInRequestModel.fromJson(Map<String, dynamic> json) {
    return CheckInRequestModel(
      name: json['name'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      timeType: json['timeType'] ?? '',
      imageKey: json['imageKey'] ?? '',
      imageUrl: json['imageUrl'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }

  CheckInRequestModel copyWith({
    String? name,
    String? date,
    String? time,
    String? timeType,
    String? imageKey,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) {
    return CheckInRequestModel(
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      timeType: timeType ?? this.timeType,
      imageKey: imageKey ?? this.imageKey,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'CheckInRequestModel(name: $name, date: $date, time: $time, '
        'timeType: $timeType, imageKey: $imageKey, imageUrl: $imageUrl, '
        'lat: $latitude, lng: $longitude)';
  }
}



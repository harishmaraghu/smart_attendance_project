class LocationAssignment {
  final String username;
  final String userId;
  final String assigningDate;
  final String location;
  final String assignedByName;

  LocationAssignment({
    required this.username,
    required this.userId,
    required this.assigningDate,
    required this.location,
    required this.assignedByName,
  });

  factory LocationAssignment.fromJson(Map<String, dynamic> json) {
    print('Parsing LocationAssignment from JSON: $json');

    try {
      return LocationAssignment(
        username: json['username']?.toString() ?? 'Unknown',
        userId: json['userId']?.toString() ?? json['userid']?.toString() ?? '',
        assigningDate: json['assigning_date']?.toString() ?? json['assigningDate']?.toString() ?? '',
        location: json['location']?.toString() ?? 'Unknown Location',
        assignedByName: json['assigned_by_name']?.toString() ?? json['assignedByName']?.toString() ?? 'Unknown',
      );
    } catch (e) {
      print('Error creating LocationAssignment: $e');
      print('JSON keys: ${json.keys.toList()}');
      rethrow;
    }
  }
}

class LocationState {
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? error;

  LocationState({
    this.latitude,
    this.longitude,
    this.address,
    this.checkInTime,
    this.checkOutTime,
    this.error,  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? error,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      error: error,
    );
  }
}

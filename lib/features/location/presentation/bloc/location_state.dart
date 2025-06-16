// Add these fields to your LocationState class

class LocationState {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? error;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool isUploadingImage;
  final String? uploadedImageUrl;
  final String? s3Key;

  // ✅ Add these new fields for navigation control
  final bool shouldNavigate;
  final String? navigationTimeType;

  const LocationState({
    this.latitude,
    this.longitude,
    this.address,
    this.error,
    this.checkInTime,
    this.checkOutTime,
    this.isUploadingImage = false,
    this.uploadedImageUrl,
    this.s3Key,
    this.shouldNavigate = false, // Default to false
    this.navigationTimeType,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? error,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    bool? isUploadingImage,
    String? uploadedImageUrl,
    String? s3Key,
    bool? shouldNavigate,
    String? navigationTimeType,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      error: error ?? this.error,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      s3Key: s3Key ?? this.s3Key,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
      navigationTimeType: navigationTimeType ?? this.navigationTimeType,
    );
  }
}
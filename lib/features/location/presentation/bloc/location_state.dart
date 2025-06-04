class LocationState {
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? error;
  final bool isUploadingImage;
  final String? uploadedImageUrl;
  final String? s3Key;

  LocationState({
    this.latitude,
    this.longitude,
    this.address,
    this.checkInTime,
    this.checkOutTime,
    this.error,
    this.isUploadingImage = false,
    this.uploadedImageUrl,
    this.s3Key,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? error,
    bool? isUploadingImage,
    String? uploadedImageUrl,
    String? s3Key,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      error: error ?? this.error,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      s3Key: s3Key ?? this.s3Key,
    );
  }

  @override
  String toString() {
    return 'LocationState(lat: $latitude, lng: $longitude, address: $address, '
        'checkIn: $checkInTime, checkOut: $checkOutTime, error: $error, '
        'uploading: $isUploadingImage, imageUrl: $uploadedImageUrl, s3Key: $s3Key)';
  }
}
// location_event.dart
abstract class LocationEvent {}

class LoadLocation extends LocationEvent {}

class CheckInPressed extends LocationEvent {}

class CheckOutPressed extends LocationEvent {}

class UploadImageToS3 extends LocationEvent {}

class RetryImageUpload extends LocationEvent {}

class UpdateImagePath extends LocationEvent {
  final String imagePath;

  UpdateImagePath(this.imagePath);
}
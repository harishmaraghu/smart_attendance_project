abstract class LocationEvent {}

class LoadLocation extends LocationEvent {}

class CheckInPressed extends LocationEvent {}

class CheckOutPressed extends LocationEvent {}

// New event to update image path dynamically
class UpdateImagePath extends LocationEvent {
  final String? imagePath;

  UpdateImagePath(this.imagePath);
}



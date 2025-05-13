import 'package:geocoding/geocoding.dart';
import 'dart:async';

class GetAddressFromCoordinates {
  Future<String?> call(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
        localeIdentifier: 'en_US', // Force English locale for consistency
      ).timeout(const Duration(seconds: 8));

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        // Build address more carefully, filtering out null or empty components
        final addressParts = [
          place.street,
          place.locality,
          place.postalCode,
          place.country,
        ].where((part) => part != null && part.isNotEmpty).toList();

        return addressParts.join(", ");
      }
      return "Address not found";
    } on TimeoutException {
      return "Address lookup timed out";
    } catch (e) {
      print("❌ Error getting address: $e");
      return "Error retrieving address";
    }
  }
}
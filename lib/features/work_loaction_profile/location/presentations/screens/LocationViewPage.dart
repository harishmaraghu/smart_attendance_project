import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/presentations/widgets/topbar_loaction.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationViewPage extends StatelessWidget {
  final String workDate;
  final String location;
  final String assignedBy;

  const LocationViewPage({
    super.key,
    required this.workDate,
    required this.location,
    required this.assignedBy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD), // Light blue background matching the image
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button

              TopDashboardinprofilelocation(),
              const SizedBox(height: 40),

              // Main content card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Icon and Title
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                size: 40,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Location Assigned',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Information Cards
                        Expanded(
                          child: Column(
                            children: [
                              // Work Date Card
                              _buildInfoCard(
                                title: 'Work Date',
                                value: workDate,
                                icon: Icons.calendar_today,
                              ),

                              const SizedBox(height: 16),

                              // Location Card
                              _buildInfoCard(
                                title: 'Location',
                                value: location,
                                icon: Icons.place,
                                isLocation: true,
                              ),

                              const SizedBox(height: 16),

                              // Assigned By Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 16,
                                            color: Color(0xFF10B981),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Assigned by $assignedBy',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Please check the new location details before marking attendance.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _shareLocation(context),
                                      icon: const Icon(Icons.share, size: 18),
                                      label: const Text(
                                        'Share',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: const BorderSide(
                                          color: Color(0xFFE2E8F0),
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _openMap(context),
                                      icon: const Icon(Icons.map, size: 18),
                                      label: const Text(
                                        'Map',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    bool isLocation = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isLocation ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: isLocation ? 1.3 : 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // Share location functionality
  void _shareLocation(BuildContext context) {
    // Create a shareable link with location details
    final String shareableLink = 'https://yourapp.com/location?date=$workDate&location=${Uri.encodeComponent(location)}&assignedBy=${Uri.encodeComponent(assignedBy)}';

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: shareableLink));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Link copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Navigate to map page
  void _openMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          location: location,
          workDate: workDate,
          assignedBy: assignedBy,
        ),
      ),
    );
  }
}

// Google Maps integrated Map Page (keeping the existing implementation)
class MapPage extends StatefulWidget {
  final String location;
  final String workDate;
  final String assignedBy;

  const MapPage({
    super.key,
    required this.location,
    required this.workDate,
    required this.assignedBy,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng? destinationLocation;
  LatLng? currentLocation;
  Set<Marker> markers = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Get current location
      await _getCurrentLocation();

      // Get destination coordinates from address
      await _getDestinationLocation();

      // Set up markers
      _setupMarkers();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading map: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      // Set default location if current location fails
      currentLocation = const LatLng(13.0827, 80.2707); // Chennai default
    }
  }

  Future<void> _getDestinationLocation() async {
    try {
      List<Location> locations = await locationFromAddress(widget.location);
      if (locations.isNotEmpty) {
        destinationLocation = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        throw 'Location not found';
      }
    } catch (e) {
      print('Error geocoding address: $e');
      // Set default destination if geocoding fails
      destinationLocation = const LatLng(13.0827, 80.2707);
    }
  }

  void _setupMarkers() {
    markers.clear();

    // Add current location marker
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
        ),
      );
    }

    // Add destination marker
    if (destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Work Location',
            snippet: widget.location,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Move camera to show both locations
    if (currentLocation != null && destinationLocation != null) {
      _fitMarkersInView();
    } else if (destinationLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(destinationLocation!, 15),
      );
    }
  }

  void _fitMarkersInView() {
    if (currentLocation != null && destinationLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          currentLocation!.latitude < destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude < destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
        northeast: LatLng(
          currentLocation!.latitude > destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude > destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
      );

      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Map'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Location info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF8FAFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.location,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Work Date: ${widget.workDate}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Google Map
          Expanded(
            child: isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading map...'),
                ],
              ),
            )
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeMap,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: destinationLocation ?? const LatLng(13.0827, 80.2707),
                zoom: 15,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: destinationLocation != null ? _openDirections : null,
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _markAttendance(context),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark Attendance'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToCurrentLocation() {
    if (currentLocation != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, 18),
      );
    }
  }

  Future<void> _openDirections() async {
    if (destinationLocation != null) {
      final String googleMapsUrl = currentLocation != null
          ? 'https://www.google.com/maps/dir/${currentLocation!.latitude},${currentLocation!.longitude}/${destinationLocation!.latitude},${destinationLocation!.longitude}'
          : 'https://www.google.com/maps/search/?api=1&query=${destinationLocation!.latitude},${destinationLocation!.longitude}';

      try {
        final Uri url = Uri.parse(googleMapsUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open Google Maps')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening directions: $e')),
          );
        }
      }
    }
  }

  void _markAttendance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to mark attendance for this location?'),
            const SizedBox(height: 12),
            Text('Location: ${widget.location}', style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('Date: ${widget.workDate}', style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Attendance marked successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Mark Attendance'),
          ),
        ],
      ),
    );
  }
}
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Map<String, dynamic>> getCurrentLocation() async {
  Map<String, dynamic> locationData = {};
  try {
    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    // Get location name from coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String locationName = getLocationName(placemarks);

    // Add data to map
    locationData['latitude'] = position.latitude;
    locationData['longitude'] = position.longitude;
    locationData['locationName'] = locationName;
  } catch (e) {
    CustomLogger.instance.error("Error getting current location: $e");
    locationData['error'] = e.toString();
  }
  return locationData;
}

String getLocationName(List<Placemark> placemarks) {
  Set<String> uniqueComponents = {};
  for (Placemark placemark in placemarks) {
    if (placemark.name != null && placemark.name!.isNotEmpty &&
        !placemark.name!.contains('Unnamed')) {
      uniqueComponents.add(placemark.name!);
    }
    if (placemark.locality != null &&
        placemark.locality!.isNotEmpty &&
        !placemark.locality!.contains('Unnamed')) {
      uniqueComponents.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty &&
        !placemark.administrativeArea!.contains('Unnamed')) {
      uniqueComponents.add(placemark.administrativeArea!);
    }
    if (placemark.country != null && placemark.country!.isNotEmpty &&
        !placemark.country!.contains('Unnamed')) {
      uniqueComponents.add(placemark.country!);
    }
  }
  // Concatenate unique components into the final location name
  String locationName = uniqueComponents.join(', ');
  return locationName;
}



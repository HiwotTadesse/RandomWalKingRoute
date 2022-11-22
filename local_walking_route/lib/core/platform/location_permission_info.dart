import 'package:geolocator/geolocator.dart';

abstract class LocationPermissionInfo {
  Future<bool> get checkPermissionInfo;
}

class LocationPermissionInfoImpl implements LocationPermissionInfo {
  final GeolocatorPlatform geolocator;

  LocationPermissionInfoImpl(this.geolocator);

  @override
  Future<bool> get checkPermissionInfo async {
    bool isGranted = false;
    LocationPermission permission = await Geolocator.checkPermission();
    final permissionResult =
        await geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isGranted = false;
        } else if (permission == LocationPermission.deniedForever) {
          isGranted = false;
        } else {
          isGranted = true;
        }
      } else {
        isGranted = true;
      }
    });
    return isGranted;
  }
}

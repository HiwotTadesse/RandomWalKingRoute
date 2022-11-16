import 'package:geolocator/geolocator.dart';

abstract class LocationPermissionInfo {
  Future<LocationPermission> checkPermissionInfo();
}

class LocationPermissionInfoImpl implements LocationPermissionInfo {
  final GeolocatorPlatform geolocator;

  LocationPermissionInfoImpl(this.geolocator);

  @override
  Future<LocationPermission> checkPermissionInfo() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission;
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';

abstract class AllInfo {
  Future<bool> isAllEnabled;
}

class AllInfoImpl implements AllInfo {
  final NetworkInfo networkInfo;
  final GpsInfo gpsInfo;
  final LocationPermissionInfo locationPermissionInfo;

  AllInfoImpl({this.networkInfo, this.gpsInfo, this.locationPermissionInfo});

  @override
  Future<bool> get isAllEnabled async {
    LocationPermission permission = await Geolocator.checkPermission();
    final isConnected = await networkInfo.isConnected;
    final isEnabled = await gpsInfo.isEnabled;
    final locationGranted =
        await locationPermissionInfo.checkPermissionInfo().then((value) async {
      if (value == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        } else if (permission == LocationPermission.deniedForever) {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    });

    return isConnected && isEnabled && locationGranted;
  }

  @override
  set isAllEnabled(Future<bool> _isAllEnabled) {
    // TODO: implement isAllEnabled
  }
}

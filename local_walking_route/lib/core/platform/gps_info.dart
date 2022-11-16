import 'package:geolocator/geolocator.dart';

abstract class GpsInfo {
  Future<bool> get isEnabled;
}

class GpsInfoImpl implements GpsInfo {
  final GeolocatorPlatform geolocator;

  GpsInfoImpl(this.geolocator);

  @override
  Future<bool> get isEnabled => geolocator.isLocationServiceEnabled();
}

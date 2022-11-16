import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';

import '../../domain/entities/CurrentLocation.dart';

abstract class CurrentLocationRemoteDataSource {
  Future<CurrentLocationModel> getCurrentLocation();
}

class CurrentLocationRemoteDataSourceImpl
    implements CurrentLocationRemoteDataSource {
  final GeolocatorPlatform geolocatorPlatform;

  const CurrentLocationRemoteDataSourceImpl({this.geolocatorPlatform});

  @override
  Future<CurrentLocationModel> getCurrentLocation() async {
    final response = await geolocatorPlatform.getCurrentPosition();
    return CurrentLocationModel.fromJson(
        {"longitude": response.longitude, "latitude": response.latitude});
  }
}

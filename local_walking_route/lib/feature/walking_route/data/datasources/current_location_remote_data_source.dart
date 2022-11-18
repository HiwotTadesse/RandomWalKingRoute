import 'dart:convert';
import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:vector_math/vector_math.dart';

import '../../../../core/constants/constant_strings.dart';
import '../../domain/entities/current_location.dart';

abstract class CurrentLocationRemoteDataSource {
  Future<CurrentLocationModel> getCurrentLocation();
  Future<Map<PolylineId, Polyline>> getRandomlyGeneratedRoutes(
      CurrentLocation currentLocation, int minute);
}

class CurrentLocationRemoteDataSourceImpl
    implements CurrentLocationRemoteDataSource {
  final GeolocatorPlatform geolocatorPlatform;

  const CurrentLocationRemoteDataSourceImpl({this.geolocatorPlatform});

  @override
  Future<CurrentLocationModel> getCurrentLocation() async {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    final response = await geolocatorPlatform.getCurrentPosition(
        locationSettings: locationSettings);
    if (response == null) {
      throw ServerException();
    }
    return CurrentLocationModel.fromJson(
        {"longitude": response.longitude, "latitude": response.latitude});
  }

  @override
  Future<Map<PolylineId, Polyline>> getRandomlyGeneratedRoutes(
      CurrentLocation currentLocation, int minute) async {
    double avarageWlkingSpeed = 5;
    double hour = minute / 60;
    double distance = hour * avarageWlkingSpeed;

    LatLng source = LatLng(currentLocation.latitude, currentLocation.longitude);

    LatLng destination1 = getDestinationPoint(source, 60, distance);
    Map<PolylineId, Polyline> firstRoute = await createPolylines(
        currentLocation.latitude,
        currentLocation.longitude,
        destination1.latitude,
        destination1.longitude);
    return firstRoute;
  }

  LatLng getDestinationPoint(LatLng source, double brng, double dist) {
    dist = dist / 6371;
    brng = radians(brng);

    double lat1 = radians(source.latitude), lon1 = radians(source.longitude);
    double lat2 =
        asin(sin(lat1) * cos(dist) + cos(lat1) * sin(dist) * cos(brng));
    double lon2 = lon1 +
        atan2(sin(brng) * sin(dist) * cos(lat1),
            cos(dist) - sin(lat1) * sin(lat2));
    if (lat2.isNaN || lon2.isNaN) {
      return null;
    }
    return LatLng(degrees(lat2), degrees(lon2));
  }

  Future<Map<PolylineId, Polyline>> createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    PolylinePoints polylinePoints;
    List<LatLng> polylineCoordinates = [];
    Map<PolylineId, Polyline> polylines = {};
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyA4PbMvGflow3VpyAMWD39wMr7PlozMNoQ",
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = const PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      //color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    polylines[id] = polyline;

    return polylines;
  }
}

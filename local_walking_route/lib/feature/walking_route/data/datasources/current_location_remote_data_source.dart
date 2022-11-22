import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz_streaming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:vector_math/vector_math.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

import '../../../../core/constants/constant_strings.dart';
import '../../domain/entities/current_location.dart';
import '../models/routes_model.dart';

abstract class CurrentLocationRemoteDataSource {
  Future<CurrentLocationModel> getCurrentLocation();
  Future<RoutesModel> getRandomlyGeneratedRoutes(
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
  Future<RoutesModel> getRandomlyGeneratedRoutes(
      CurrentLocation currentLocation, int minute) async {
    double avarageWlkingSpeed = 3.25;
    double second = minute / 60;
    double distance = (second * avarageWlkingSpeed);

    LatLng source = LatLng(currentLocation.latitude, currentLocation.longitude);
    double radius = (distance) / 2;

    List<RouteModel> routesList1 = [];

    for (var j = 0; j < 10; j++) {
      for (var i = 1; i < 5; i++) {
        RouteModel dect1 = getDestinationPoint(source, -10.0 * i, radius / 50);

        routesList1.add(dect1);
        source = LatLng(routesList1[routesList1.length - 1].latitude,
            routesList1[routesList1.length - 1].longitude);
      }
    }
    for (var j = 0; j < 10; j++) {
      for (var i = 1; i < 10; i++) {
        source = LatLng(routesList1[routesList1.length - 1].latitude,
            routesList1[routesList1.length - 1].longitude);
        RouteModel dect1 = getDestinationPoint(source, 15.0 * i, radius / 100);

        routesList1.add(dect1);
      }
    }

    for (var j = 0; j < 10; j++) {
      for (var i = 1; i < 5; i++) {
        source = LatLng(routesList1[routesList1.length - 1].latitude,
            routesList1[routesList1.length - 1].longitude);
        RouteModel dect1 = getDestinationPoint(source, 150.0, radius / 50);
        routesList1.add(dect1);
      }
    }

    for (var j = 0; j < 7; j++) {
      source = LatLng(routesList1[routesList1.length - 1].latitude,
          routesList1[routesList1.length - 1].longitude);
      RouteModel dect1 = getDestinationPoint(source, -105.0, radius / 10);
      routesList1.add(dect1);
    }
    routesList1.add(RouteModel(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude));
    List<RouteModel> allRoutesList = [routesList1].expand((x) => x).toList();

    RoutesModel polylineCoordinates = RoutesModel(routesModel: allRoutesList);
    return polylineCoordinates;
  }

  RouteModel getDestinationPoint(LatLng source, double brng, double dist) {
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
    return RouteModel(latitude: degrees(lat2), longitude: degrees(lon2));
  }

  /*RouteModel getRandomPointsBetweenLine(LatLng source, LatLng destination) {
    Random random = Random();

    double u = random.nextDouble();
    LatLng latLng = LatLng(
        (1 - u) * source.latitude + (1 - u) * source.latitude,
        (u) * destination.longitude + (u) * destination.longitude);
    RouteModel routeModel =
        RouteModel(latitude: latLng.latitude, longitude: latLng.longitude);

    return routeModel;
  }*/

/*  Future<List<RouteModel>> getForwardRoutes(
      double distance, RouteModel routeModel,
      {int minute}) async {
    List<RouteModel> resultRoutesList = [];
    var source = LatLng(routeModel.latitude, routeModel.longitude);
    double radius = distance / 2;
    List<RouteModel> routesList = [];
    Map<String, dynamic> getminimumRoute = {};

    while (radius > 0) {
      double radius2 = radius / minute;

      if (radius <= (minute)) {
        radius2 = radius;
      }

      radius = radius - radius2;
      if (radius < 1) {
        radius2 = 0;
        radius = 0;
      }

      while (radius2 > 0) {
        double routeDistance = 0;
        radius2 = radius2 / 2;
        routesList = await getListOfRandomRoutes(30, source, radius2,
            backward: false, forward: true);

        getminimumRoute =
            await getMinimumDistancedRoute(routesList, routeModel);

        routeDistance = getminimumRoute['distance'];
        if (routeDistance < radius2) {
          resultRoutesList.add(getminimumRoute['the_next_source']);
          radius2 = radius2 - getminimumRoute['distance'];
          source = LatLng(getminimumRoute['the_next_source'].latitude,
              getminimumRoute['the_next_source'].longitude);
        } else {
          radius = radius + radius2;
          radius2 = 0;
        }
      }
    }

    return resultRoutesList;
  }

  Future<List<RouteModel>> getBackwardRoutes(
      double distance, RouteModel routeModel,
      {int minute}) async {
    List<RouteModel> resultRoutesList = [];
    var source = LatLng(routeModel.latitude, routeModel.longitude);
    double radius = distance / 2;
    List<RouteModel> routesList = [];
    Map<String, dynamic> getminimumRoute = {};

    while (radius > 0) {
      double radius2 = radius / minute;

      if (radius <= (minute)) {
        radius2 = radius;
      }

      radius = radius - radius2;
      if (radius < 1) {
        radius2 = 0;
        radius = 0;
      }

      while (radius2 > 0) {
        radius2 = radius2 / 2;
        double routeDistance = 0;
        routesList = await getListOfRandomRoutes(30, source, radius,
            forward: false, backward: true);
        getminimumRoute =
            await getMinimumDistancedRoute(routesList, routeModel);

        routeDistance = getminimumRoute['distance'];
        if (routeDistance < radius2) {
          resultRoutesList.add(getminimumRoute['the_next_source']);
          radius2 = radius2 - getminimumRoute['distance'];
          source = LatLng(getminimumRoute['the_next_source'].latitude,
              getminimumRoute['the_next_source'].longitude);
        } else {
          radius = radius + radius2;
          radius2 = 0;
        }
      }
    }

    return resultRoutesList;
  }

  Future<List<RouteModel>> getListOfRandomRoutes(
      int iteration, LatLng source, double radius,
      {bool forward, bool backward, double angle}) async {
    List<RouteModel> routesList = [];

    if (backward) {
      for (var i = 0; i < iteration; i++) {
        final result1 = getRandomLocation2(source, radius,
            angle: angle, forward: forward, backward: backward);
        routesList.add(RouteModel(
            latitude: result1.latitude, longitude: result1.longitude));
      }
    }
    for (var i = 0; i < iteration; i++) {
      final result1 = getRandomLocation(source, radius,
          angle: angle, forward: forward, backward: backward);
      routesList.add(
          RouteModel(latitude: result1.latitude, longitude: result1.longitude));
    }
    return routesList;
  }

  Future<Map<String, dynamic>> getMinimumDistancedRoute(
      List<RouteModel> list, RouteModel source) async {
    Map<dynamic, dynamic> pointsWithThereDistance = <dynamic, dynamic>{};

    for (var item in list) {
      double distanceInMeters = geolocatorPlatform.distanceBetween(
          source.latitude, source.longitude, item.latitude, item.longitude);
      pointsWithThereDistance[distanceInMeters] = item;
    }

    final fromDictToList = pointsWithThereDistance.keys.toList();
    final minval = fromDictToList.sort();
    Map<String, dynamic> result = {
      "the_next_source": pointsWithThereDistance[fromDictToList.first],
      "distance": fromDictToList.first,
    };
    return result;
  }

  LatLng getRandomLocation(
    LatLng point,
    double radius, {
    bool forward = true,
    bool backward = false,
    double angle,
  }) {
    var randomAngles = [30, 120];
    double x0 = point.latitude;
    double y0 = point.longitude;

    Random random = Random();
    double radiusInDegrees = radius / 111300;

    double u = random.nextDouble();
    //double v = random.nextDouble();
    double w = radiusInDegrees * sqrt(u);
    int t = randomAngles[random.nextInt(randomAngles.length)]; //pi * v;
    double x = w * cos(t);
    double y = w * sin(t);
    double foundLatitude = x + x0;
    double foundLongitude = y + y0;
    LatLng randomLatLng = LatLng(foundLatitude, foundLongitude);

    Map<String, dynamic> result = {
      "latitude_longtude": randomLatLng,
      "angle": t
    };
    return randomLatLng;
  }

  LatLng getRandomLocation2(LatLng point, double radius,
      {bool forward = false, bool backward = true, double angle}) {
    var randomAngles = [-30, -120];
    double x0 = point.latitude;
    double y0 = point.longitude;

    Random random = Random();
    double radiusInDegrees = radius / 111300;

    double u = random.nextDouble();
    double v = random.nextDouble();
    double w = radiusInDegrees * sqrt(u);
    int t = randomAngles[random.nextInt(randomAngles.length)];
    double x = w * cos(t);
    double y = w * sin(t);

    LatLng randomLatLng = const LatLng(0.0, 0.0);
    if (backward) {
      double foundLatitude = x0 - x;
      double foundLongitude = y0 - y;
      randomLatLng = LatLng(foundLatitude, foundLongitude);
    }

    Map<String, dynamic> result = {
      "latitude_longtude": randomLatLng,
      "angle": t
    };
    return randomLatLng;
  }*/
}

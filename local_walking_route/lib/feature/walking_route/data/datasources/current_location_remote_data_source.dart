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
import 'package:open_route_service/open_route_service.dart';
import 'package:vector_math/vector_math.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

import '../../../../core/constants/constant_strings.dart';
import '../../domain/entities/current_location.dart';
import '../models/routes_model.dart';
import 'package:http/http.dart' as http;

abstract class CurrentLocationRemoteDataSource {
  Future<CurrentLocationModel> getCurrentLocation();
  Future<List<RoutesModel>> getRandomlyGeneratedRoutes(
      CurrentLocation currentLocation, int minute);
}

class CurrentLocationRemoteDataSourceImpl
    implements CurrentLocationRemoteDataSource {
  final GeolocatorPlatform geolocatorPlatform;
  final OpenRouteService openRouteService =
      OpenRouteService(apiKey: Strings.ROUTE_API_KEY);

  CurrentLocationRemoteDataSourceImpl(
      {this.geolocatorPlatform, openRouteService});

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
  Future<List<RoutesModel>> getRandomlyGeneratedRoutes(
      CurrentLocation currentLocation, int minute) async {
    double avarageWlkingSpeed = 3.25;
    double second = minute / 60;
    double distance = (second * avarageWlkingSpeed);

    LatLng source = LatLng(currentLocation.latitude, currentLocation.longitude);
    double radius = (distance) / 2;
    RouteModel destination = getDestinationPoint(source, 30, distance / 3);

    List<RouteModel> routePoints = [];
    List<RouteModel> routePoints1 = [];
    List<RouteModel> routePoints2 = [];
    List<ORSCoordinate> routeCoordinates =
        await openRouteService.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude),
      endCoordinate: ORSCoordinate(
          latitude: destination.latitude, longitude: destination.longitude),
    );
    RouteModel destination2 = getDestinationPoint(source, 60, distance / 3);

    List<ORSCoordinate> routeCoordinates1 =
        await openRouteService.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: routeCoordinates[0].latitude,
          longitude: routeCoordinates[0].longitude),
      endCoordinate: ORSCoordinate(
          latitude: destination2.latitude, longitude: destination2.longitude),
    );

    List<ORSCoordinate> routeCoordinates2 =
        await openRouteService.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: routeCoordinates[routeCoordinates.length - 1].latitude,
          longitude: routeCoordinates[routeCoordinates.length - 1].longitude),
      endCoordinate: ORSCoordinate(
          latitude: routeCoordinates1[routeCoordinates1.length - 1].latitude,
          longitude: routeCoordinates1[routeCoordinates1.length - 1].longitude),
    );

    routePoints = routeCoordinates
        .map((coordinate) => RouteModel(
            latitude: coordinate.latitude, longitude: coordinate.longitude))
        .toList();

    routePoints1 = routeCoordinates1
        .map((coordinate) => RouteModel(
            latitude: coordinate.latitude, longitude: coordinate.longitude))
        .toList();

    routePoints2 = routeCoordinates2
        .map((coordinate) => RouteModel(
            latitude: coordinate.latitude, longitude: coordinate.longitude))
        .toList();

    if (routePoints == null) {
      throw ServerException();
    }
    List<RoutesModel> polylineCoordinates = [
      RoutesModel(routesModel: routePoints),
      RoutesModel(routesModel: routePoints1),
      RoutesModel(routesModel: routePoints2)
    ];
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
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/constants/constant_strings.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:mockito/mockito.dart';
import 'package:open_route_service/open_route_service.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGeolocator extends Mock implements GeolocatorPlatform {}

class MockOpenRouteService extends Mock implements OpenRouteService {}

void main() {
  CurrentLocationRemoteDataSourceImpl datasource;
  MockGeolocator mockGeolocator;
  MockOpenRouteService mockOpenRouteService;

  setUp(() {
    mockGeolocator = MockGeolocator();
    datasource =
        CurrentLocationRemoteDataSourceImpl(geolocatorPlatform: mockGeolocator);
    mockOpenRouteService = MockOpenRouteService();
    mockOpenRouteService.setProfile = ORSProfile.footWalking;
  });

  group('getCurrentLocation', () {
    final tCurrentLocation = CurrentLocationModel.fromJson(
        json.decode(fixture('current_location.json')));
    test('should get the current position of the user', () async {
      when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async =>
          Position.fromMap(json.decode(fixture('current_location.json'))));

      final call = datasource.getCurrentLocation;
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomCoordinates', () {
    const tRouteModel1 = RouteModel(longitude: 11.2, latitude: 12.3);
    const tRouteModel2 = RouteModel(longitude: 11.2, latitude: 12.3);
    const tRoutesModel = RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);
    const tRoutesModel2 =
        RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);
    List<RoutesModel> tRoutesModelList = [tRoutesModel, tRoutesModel2];
    const tCurrentLocation = CurrentLocation(latitude: 1.1, longitude: 1.2);
    const tMinute = 1;

    setUp(() {});

    test('should get the current position of the user', () async {
      when(mockOpenRouteService.directionsRouteCoordsGet(
              startCoordinate: ORSCoordinate(
                  latitude: tRouteModel1.latitude,
                  longitude: tRouteModel1.longitude),
              endCoordinate: ORSCoordinate(
                  latitude: tRouteModel2.latitude,
                  longitude: tRouteModel2.longitude)))
          .thenAnswer((_) async => List<ORSCoordinate>.from(tRoutesModelList));

      final call = datasource.getRandomlyGeneratedRoutes;
      expect(() => call(tCurrentLocation, tMinute),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

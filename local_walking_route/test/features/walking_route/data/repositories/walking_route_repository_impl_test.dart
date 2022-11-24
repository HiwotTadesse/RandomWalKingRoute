import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/data/repositories/walking_route_repository_impl.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock
    implements CurrentLocationRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGpsInfo extends Mock implements GpsInfo {}

class MockLocationPermissionInfo extends Mock
    implements LocationPermissionInfo {}

void main() {
  WalkingRouteRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockGpsInfo mockGpsInfo;
  MockLocationPermissionInfo mockLocationPermissionInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockGpsInfo = MockGpsInfo();
    mockLocationPermissionInfo = MockLocationPermissionInfo();
    repositoryImpl = WalkingRouteRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo,
        gpsInfo: mockGpsInfo,
        locationPermissionInfo: mockLocationPermissionInfo);
  });
  group('getCurrentLocation', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => true);
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => true);
    });
    /* test('should check if the device is online', () async {
      repositoryImpl.getCurrentLocation();
      verify(mockNetworkInfo.isConnected);
    });*/

    test('should check if the device is online', () async {
      repositoryImpl.getCurrentLocation();
      verify(mockGpsInfo.isEnabled);
    }); /*

    test('should check if the device is online', () async {
      repositoryImpl.getCurrentLocation();
      verify(mockLocationPermissionInfo.checkPermissionInfo);
    });*/
  });

  group('the device is all enabled', () {
    final tCurrentLocationModel =
        CurrentLocationModel(longitude: 11.2, latitude: 12.4);
    final tCurrentLocation = tCurrentLocationModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => true);
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => true);
    });

    test(
        'should return server failure when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenAnswer((_) async => tCurrentLocation);

      final result = await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
      expect(result, equals(Right(tCurrentLocation)));
    });
  });

  group('the device gps is all not enabled', () {
    final tCurrentLocationModel =
        CurrentLocationModel(longitude: 11.2, latitude: 12.4);
    final tCurrentLocation = tCurrentLocationModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => false);
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => true);
    });

    test(
        'should return server failure when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation()).thenThrow(GpsException());

      final result = await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
      expect(result, equals(left(GpsFailure())));
    });
  });

  group('the device connection is all not enabled', () {
    final tCurrentLocationModel =
        CurrentLocationModel(longitude: 11.2, latitude: 12.4);
    final tCurrentLocation = tCurrentLocationModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => true);
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => false);
    });

    test(
        'should return server failure when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenThrow(PermissionException());

      final result = await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
      expect(result, equals(left(PermissionFailure())));
    });
  });

  group('the device connection is all not enabled', () {
    final tCurrentLocationModel =
        CurrentLocationModel(longitude: 11.2, latitude: 12.4);
    final tCurrentLocation = tCurrentLocationModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => true);
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => true);
    });

    test(
        'should return server failure when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenThrow(ConnectionException());

      final result = await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
      expect(result, equals(left(ConnectionFailure())));
    });
  });

  group('the device connection is all not enabled', () {
    const tCurrentLocation = CurrentLocation(latitude: 1.1, longitude: 1.2);
    const tMinute = 1;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
        'should return server failure when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenThrow(ConnectionException());

      final result =
          await repositoryImpl.getRandomSetOfRoutes(tCurrentLocation, tMinute);

      verify(mockRemoteDataSource.getRandomlyGeneratedRoutes(
          tCurrentLocation, tMinute));
      expect(result, equals(left(ConnectionFailure())));
    });
  });

  group('the device is all enabled', () {
    const tCurrentLocation = CurrentLocation(latitude: 1.1, longitude: 1.2);
    const tMinute = 1;

    const tRouteModel1 = RouteModel(longitude: 11.2, latitude: 12.3);
    const tRouteModel2 = RouteModel(longitude: 11.2, latitude: 12.3);
    const tRoutesModel = RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);
    const tRoutesModel2 =
        RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);
    List<RoutesModel> tRoutesModelList = [tRoutesModel, tRoutesModel2];

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return with coordinates when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getRandomlyGeneratedRoutes(
              tCurrentLocation, tMinute))
          .thenAnswer((_) async => tRoutesModelList);

      final result =
          await repositoryImpl.getRandomSetOfRoutes(tCurrentLocation, tMinute);

      verify(mockRemoteDataSource.getRandomlyGeneratedRoutes(
          tCurrentLocation, tMinute));
      expect(result, equals(Right(tRoutesModelList)));
    });
  });
}

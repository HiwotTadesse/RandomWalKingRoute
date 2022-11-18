import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/core/platform/all_in_one_info.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:local_walking_route/feature/walking_route/data/repositories/walking_route_repository_impl.dart';
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
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repositoryImpl.getCurrentLocation();
      verify(mockNetworkInfo.isConnected);
    });

    test('should check if the device\'s gps location enabled', () async {
      when(mockGpsInfo.isEnabled).thenAnswer((_) async => true);
      repositoryImpl.getCurrentLocation();
      verify(mockGpsInfo.isEnabled);
    });

    test('should check if the user has garanted permission', () async {
      when(mockLocationPermissionInfo.checkPermissionInfo())
          .thenAnswer((_) async => LocationPermission.always);
      repositoryImpl.getCurrentLocation();
      verify(mockLocationPermissionInfo.checkPermissionInfo());
    });
  });

  group('the device is all enabled', () {
    final tCurrentLocationModel =
        CurrentLocationModel(longitude: 11.2, latitude: 12.4);
    final tCurrentLocation = tCurrentLocationModel;

    setUp(() {
      // when(mockAllInfo.isAllEnabled).thenAnswer((_) async => true);
    });

    test(
        'should return the current location when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenAnswer((_) async => tCurrentLocationModel);

      await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getCurrentLocation())
          .thenThrow(ServerException());

      final result = await repositoryImpl.getCurrentLocation();

      verify(mockRemoteDataSource.getCurrentLocation());
      expect(result, equals(Left(ServerFailure())));
    });
  });
}

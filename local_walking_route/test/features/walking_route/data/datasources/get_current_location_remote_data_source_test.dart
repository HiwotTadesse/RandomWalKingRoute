import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  CurrentLocationRemoteDataSourceImpl datasource;
  MockGeolocator mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    datasource =
        CurrentLocationRemoteDataSourceImpl(geolocatorPlatform: mockGeolocator);
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
    final tCurrentLocation = CurrentLocationModel.fromJson(
        json.decode(fixture('current_location.json')));
    test('should get the current position of the user', () async {
      when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async =>
          Position.fromMap(json.decode(fixture('current_location.json'))));

      final call = datasource.getCurrentLocation;
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

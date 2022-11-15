import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/data/repositories/walking_route_repository_impl.dart';
import 'package:mockito/mockito.dart';

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
      verify(mockNetworkInfo.isConnected);
    });

    test('should check if the user has garanted permission', () async {
      when(mockLocationPermissionInfo.checkPermissionInfo)
          .thenAnswer((_) async => true);
      repositoryImpl.getCurrentLocation();
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () async {});
}

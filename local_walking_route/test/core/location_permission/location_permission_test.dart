import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:mockito/mockito.dart';

class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  LocationPermissionInfoImpl locationPermissionInfoImpl;
  MockGeolocator mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    locationPermissionInfoImpl = LocationPermissionInfoImpl(mockGeolocator);
  });

  group('isGranted', () {
    // test('should forward the call to GeolocatorPlatform.checkPermission()',
    //     () async {
    //   final tCheckPermission = Future.value(LocationPermission.always);
    //   WidgetsFlutterBinding.ensureInitialized();

    //   when(mockGeolocator.checkPermission())
    //       .thenAnswer((_) => tCheckPermission);

    //   final result = await locationPermissionInfoImpl.checkPermissionInfo();

    //   expect(result, tCheckPermission);
    // });
  });
}

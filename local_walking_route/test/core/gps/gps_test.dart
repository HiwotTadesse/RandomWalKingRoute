import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:mockito/mockito.dart';

class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  GpsInfoImpl gpsInfoImpl;
  MockGeolocator mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    gpsInfoImpl = GpsInfoImpl(mockGeolocator);
  });

  group('isEnabled', () {
    test(
        'should forward the call to GeolocatorPlatform.isLocationServiceEnabled',
        () async {
      final tLocationServiceEnabled = Future.value(true);

      when(mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) => tLocationServiceEnabled);

      final result = gpsInfoImpl.isEnabled;

      verify(mockGeolocator.isLocationServiceEnabled());

      expect(result, tLocationServiceEnabled);
    });
  });
}

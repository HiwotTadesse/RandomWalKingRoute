import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/getCurrent_location_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_state.dart';
import 'package:mockito/mockito.dart';

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

void main() {
  CurrentLocationBloc currentLocationBloc;
  MockGetCurrentLocation mockGetCurrentLocation;

  setUp(() {
    mockGetCurrentLocation = MockGetCurrentLocation();
    currentLocationBloc = CurrentLocationBloc(location: mockGetCurrentLocation);
  });

  test('initialState should be Empty', () async {
    expect(currentLocationBloc.initialState, CurrentLocationInitial());
  });

  test(
      'should wait for 3 seconds before the get current position event dispatched',
      () async {
    currentLocationBloc.add(GetCurrentLocationEvent());
  });
}

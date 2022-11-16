import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_state.dart';
import 'package:mockito/mockito.dart';

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

void main() {
  WalkingRouteBloc walkingRouteBlocBloc;
  MockGetCurrentLocation mockGetCurrentLocation;

  setUp(() {
    mockGetCurrentLocation = MockGetCurrentLocation();
    walkingRouteBlocBloc = WalkingRouteBloc(location: mockGetCurrentLocation);
  });

  test('initialState should be Empty', () async {
    expect(walkingRouteBlocBloc.initialState, WalkingRouteInitial());
  });

  // test(
  //     'should wait for 3 seconds before the get current position event dispatched',
  //     () async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   walkingRouteBlocBloc.add(GetCurrentLocationEvent());
  //   verify()
  // });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/core/utils/input_converter.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_state.dart';
import 'package:mockito/mockito.dart';

class MockGetRandomRoute extends Mock implements GetRandomRoute {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  RandomRoutesBloc randomRoutesBloc;
  MockGetRandomRoute mockGetRandomRoute;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomRoute = MockGetRandomRoute();
    mockInputConverter = MockInputConverter();
    randomRoutesBloc = RandomRoutesBloc(
        routes: mockGetRandomRoute, inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () async {
    expect(randomRoutesBloc.initialState, RandomRoutesInitial());
  });

  group('get Random Routes', () {
    final tMinute = '12';
    final tMinuteParsed = int.parse(tMinute);
    final tCurrentLocation = CurrentLocation(longitude: 12.33, latitude: 11.33);

    const tRouteModel1 = RouteModel(longitude: 11.2, latitude: 12.3);
    const tRouteModel2 = RouteModel(longitude: 11.2, latitude: 12.3);
    final tRoutesModel = RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tMinuteParsed));
        randomRoutesBloc.add(GetRandomRoutesEvent(
            minute: tMinute, currentLocation: tCurrentLocation));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        verify(mockInputConverter.stringToUnsignedInteger(tMinute));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        final expected = [
          RandomRoutesInitial(),
          const RandomRoutesError(message: "Invalid Input"),
        ];

        expectLater(randomRoutesBloc.state, emitsInOrder(expected));
        randomRoutesBloc.add(GetRandomRoutesEvent(
            minute: tMinute, currentLocation: tCurrentLocation));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tMinuteParsed));

        when(mockGetRandomRoute(any))
            .thenAnswer((_) async => Right(tRoutesModel));

        randomRoutesBloc.add(GetRandomRoutesEvent(
            minute: tMinute, currentLocation: tCurrentLocation));
        final expected = [
          RandomRoutesInitial(),
          RandomRoutesLoading(),
          RandomRoutesLoaded(setOfRoutes: tRoutesModel),
        ];
        expectLater(randomRoutesBloc.state, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Loading, error] when data is gotten unsuccessfully',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tMinuteParsed));

        when(mockGetRandomRoute(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        randomRoutesBloc.add(GetRandomRoutesEvent(
            minute: tMinute, currentLocation: tCurrentLocation));
        final expected = [
          RandomRoutesInitial(),
          RandomRoutesLoading(),
          const RandomRoutesError(message: "Server Failure"),
        ];
        expectLater(randomRoutesBloc.state, emitsInOrder(expected));
      },
    );
  });
}

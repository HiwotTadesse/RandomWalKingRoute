import 'package:dartz/dartz.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWalkingRoutesRepository extends Mock
    implements WalkingRouteRepository {}

void main() {
  GetRandomRoute usecase;
  MockWalkingRoutesRepository mockWalkingRoutesRepository;

  setUp(() {
    mockWalkingRoutesRepository = MockWalkingRoutesRepository();
    usecase = GetRandomRoute(mockWalkingRoutesRepository);
  });

  const tCurrentLocation = CurrentLocation(latitude: 1.1, longitude: 1.2);
  const tMinute = 1;
  const tRouteModel1 = RouteModel(longitude: 11.2, latitude: 12.3);
  const tRouteModel2 = RouteModel(longitude: 11.2, latitude: 12.3);
  const tRoutesModel = RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);

  test('should get set of routes from repository', () async {
    // when(mockWalkingRoutesRepository.getRandomSetOfRoutes(
    //       tCurrentLocation, tMinute))
    // .thenAnswer((_) async => const Right());

    final result = await usecase(
        const Params(minutes: tMinute, currentLocation: tCurrentLocation));

    expect(result, const Right(tRoutesModel));

    verify(mockWalkingRoutesRepository.getRandomSetOfRoutes(
        tCurrentLocation, tMinute));
    verifyNoMoreInteractions(mockWalkingRoutesRepository);
  });
}

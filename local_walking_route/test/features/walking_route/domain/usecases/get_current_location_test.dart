import 'package:dartz/dartz.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWalkingRoutesRepository extends Mock
    implements WalkingRouteRepository {}

void main() {
  GetCurrentLocation usecase;
  MockWalkingRoutesRepository mockWalkingRoutesRepository;

  setUp(() {
    mockWalkingRoutesRepository = MockWalkingRoutesRepository();
    usecase = GetCurrentLocation(mockWalkingRoutesRepository);
  });

  const tCurrentLocation = CurrentLocation(latitude: 1.1, longitude: 1.2);

  test("should get current position from repository", () async {
    when(mockWalkingRoutesRepository.getCurrentLocation())
        .thenAnswer((_) async => const Right(tCurrentLocation));

    final result = await usecase(NoParams());

    expect(result, const Right(tCurrentLocation));

    verify(mockWalkingRoutesRepository.getCurrentLocation());

    verifyNoMoreInteractions(mockWalkingRoutesRepository);
  });
}

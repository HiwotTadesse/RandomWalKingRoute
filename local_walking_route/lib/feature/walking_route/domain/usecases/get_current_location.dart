import 'package:dartz/dartz.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';

import '../../../../core/error/failures.dart';

class GetCurrentLocation extends UseCase<CurrentLocation, NoParams> {
  final WalkingRouteRepository walkingRouteRepository;

  GetCurrentLocation(this.walkingRouteRepository);

  @override
  Future<Either<Failure, CurrentLocation>> call(NoParams params) async {
    return await walkingRouteRepository.getCurrentLocation();
  }
}

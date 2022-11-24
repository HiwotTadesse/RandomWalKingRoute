import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/route.dart';
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

class GetRandomRoute extends UseCase<List<RoutesModel>, Params> {
  final WalkingRouteRepository walkingRouteRepository;

  GetRandomRoute(this.walkingRouteRepository);

  @override
  Future<Either<Failure, List<RoutesModel>>> call(Params params) async {
    return await walkingRouteRepository.getRandomSetOfRoutes(
        params.currentLocation, params.minutes);
  }
}

import 'package:dartz/dartz.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';

abstract class WalkingRouteRepository {
  Future<Either<Failure, CurrentLocation>> getCurrentLocation();
}

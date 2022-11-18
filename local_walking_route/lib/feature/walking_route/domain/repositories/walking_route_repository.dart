import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';

import '../entities/route.dart';

abstract class WalkingRouteRepository {
  Future<Either<Failure, CurrentLocation>> getCurrentLocation();
  Future<Either<Failure, Map<PolylineId, Polyline>>> getRandomSetOfRoutes(
      CurrentLocation currentLocation, int minute);
}

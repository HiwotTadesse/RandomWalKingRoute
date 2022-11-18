import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/core/platform/all_in_one_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';

import '../../../../core/platform/gps_info.dart';
import '../../../../core/platform/network_info.dart';

class WalkingRouteRepositoryImpl extends WalkingRouteRepository {
  final CurrentLocationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final GpsInfo gpsInfo;
  final LocationPermissionInfo locationPermissionInfo;

  WalkingRouteRepositoryImpl(
      {this.remoteDataSource,
      this.networkInfo,
      this.gpsInfo,
      this.locationPermissionInfo});

  @override
  Future<Either<Failure, CurrentLocation>> getCurrentLocation() async {
    try {
      final networkResult = await networkInfo.isConnected;
      final gpsResult = await gpsInfo.isEnabled;
      LocationPermission permission = await Geolocator.checkPermission();
      final permissionResult = await locationPermissionInfo
          .checkPermissionInfo()
          .then((value) async {
        if (value == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return false;
          } else if (permission == LocationPermission.deniedForever) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      });
      if (networkResult && gpsResult && permissionResult) {
        final remoteCurrentLocation =
            await remoteDataSource.getCurrentLocation();
        return Right(remoteCurrentLocation);
      } else {
        if (!networkResult) {
          return Left(ConnectionFailure());
        } else if (!gpsResult) {
          return Left(GpsFailure());
        } else if (!permissionResult) {
          return Left(PermissionFailure());
        } else {
          throw ServerException();
        }
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<PolylineId, Polyline>>> getRandomSetOfRoutes(
      CurrentLocation currentLocation, int minute) async {
    final remoteCurrentLocation = await remoteDataSource
        .getRandomlyGeneratedRoutes(currentLocation, minute);
    return Right(remoteCurrentLocation);
  }
}

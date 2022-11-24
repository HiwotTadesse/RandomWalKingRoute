import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/error/exceptions.dart';
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
    if (await gpsInfo.isEnabled &&
        await networkInfo.isConnected &&
        await locationPermissionInfo.checkPermissionInfo) {
      try {
        final remoteCurrentLocation =
            await remoteDataSource.getCurrentLocation();
        return Right(remoteCurrentLocation);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        if (!await networkInfo.isConnected) {
          await remoteDataSource.getCurrentLocation();
          throw ConnectionException();
        } else if (!await gpsInfo.isEnabled) {
          await remoteDataSource.getCurrentLocation();
          throw GpsException();
        } else if (!await locationPermissionInfo.checkPermissionInfo) {
          await remoteDataSource.getCurrentLocation();
          throw PermissionException();
        } else {
          throw ServerException();
        }
      } on ConnectionException {
        return Left(ConnectionFailure());
      } on GpsException {
        return Left(GpsFailure());
      } on PermissionException {
        return Left(PermissionFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<RoutesModel>>> getRandomSetOfRoutes(
      CurrentLocation currentLocation, int minute) async {
    if (await networkInfo.isConnected) {
      try {
        final routes = await remoteDataSource.getRandomlyGeneratedRoutes(
            currentLocation, minute);
        return Right(routes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        if (!await networkInfo.isConnected) {
          await remoteDataSource.getRandomlyGeneratedRoutes(
              currentLocation, minute);
          throw ConnectionException();
        } else {
          throw ServerException();
        }
      } on ConnectionException {
        return Left(ConnectionFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }
}

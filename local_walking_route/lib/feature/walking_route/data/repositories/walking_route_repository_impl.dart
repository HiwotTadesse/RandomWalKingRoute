import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';
import 'package:local_walking_route/feature/walking_route/data/datasources/current_location_remote_data_source.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';

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
  Future<Either<Failure, CurrentLocation>> getCurrentLocation() {
    networkInfo.isConnected;
    gpsInfo.isEnabled;
    locationPermissionInfo.checkPermissionInfo;
    return null;
  }
}

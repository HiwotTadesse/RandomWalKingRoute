import 'package:local_walking_route/core/error/exceptions.dart';
import 'package:local_walking_route/core/platform/all_in_one_info.dart';
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
  final AllInfo allInfo;

  WalkingRouteRepositoryImpl({
    this.remoteDataSource,
    this.allInfo,
  });

  @override
  Future<Either<Failure, CurrentLocation>> getCurrentLocation() async {
    try {
      final info = await allInfo.isAllEnabled;
      if (info) {
        final remoteCurrentLocation =
            await remoteDataSource.getCurrentLocation();
        return Right(remoteCurrentLocation);
      } else {
        throw ServerException;
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

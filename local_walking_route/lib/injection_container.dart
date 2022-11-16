import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:local_walking_route/core/platform/all_in_one_info.dart';
import 'package:local_walking_route/core/platform/gps_info.dart';
import 'package:local_walking_route/core/platform/location_permission_info.dart';
import 'package:local_walking_route/core/platform/network_info.dart';
import 'package:local_walking_route/feature/walking_route/data/repositories/walking_route_repository_impl.dart';
import 'package:local_walking_route/feature/walking_route/domain/repositories/walking_route_repository.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_bloc_bloc.dart';

import 'feature/walking_route/data/datasources/current_location_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => WalkingRouteBlocBloc(
      location: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCurrentLocation(sl()));

  sl.registerLazySingleton<WalkingRouteRepository>(
    () => WalkingRouteRepositoryImpl(remoteDataSource: sl(), allInfo: sl()),
  );

  sl.registerLazySingleton<CurrentLocationRemoteDataSource>(
    () => CurrentLocationRemoteDataSourceImpl(geolocatorPlatform: sl()),
  );
  sl.registerLazySingleton<AllInfo>(() => AllInfoImpl(
      networkInfo: sl(), gpsInfo: sl(), locationPermissionInfo: sl()));
  sl.registerLazySingleton<GpsInfo>(() => GpsInfoImpl(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<LocationPermissionInfo>(
      () => LocationPermissionInfoImpl(sl()));

  final geolocatorPlatform = GeolocatorPlatform.instance;
  sl.registerLazySingleton(() => geolocatorPlatform);
  sl.registerLazySingleton(() => DataConnectionChecker());
}

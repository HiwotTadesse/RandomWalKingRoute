import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';

abstract class CurrentLocationRemoteDataSource {
  Future<CurrentLocationModel> getCurrentLocation();
}

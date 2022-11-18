import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'dart:convert';

import 'package:local_walking_route/feature/walking_route/domain/entities/route.dart';

class RouteModel extends Route {
  const RouteModel({longitude, latitude})
      : super(latitude: latitude, longitude: longitude);

  factory RouteModel.fromJson(Map<String, dynamic> mapData) {
    return RouteModel(
        latitude: mapData['latitude'], longitude: mapData['longitude']);
  }

  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}

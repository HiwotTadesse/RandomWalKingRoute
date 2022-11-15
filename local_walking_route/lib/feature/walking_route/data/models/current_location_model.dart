import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';
import 'dart:convert';

class CurrentLocationModel extends CurrentLocation {
  const CurrentLocationModel({longitude, latitude})
      : super(latitude: latitude, longitude: longitude);

  factory CurrentLocationModel.fromJson(Map<String, dynamic> mapData) {
    return CurrentLocationModel(
        latitude: mapData['latitude'], longitude: mapData['longitude']);
  }

  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}

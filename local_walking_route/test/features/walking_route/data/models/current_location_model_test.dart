import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/feature/walking_route/data/models/current_location_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCurrentLocation =
      CurrentLocationModel(longitude: 11.2, latitude: 12.3);

  test('should return a valid model when the JSON number is an double',
      () async {
    final Map<String, dynamic> jsonmap =
        json.decode(fixture('current_location.json'));

    final result = CurrentLocationModel.fromJson(jsonmap);

    expect(result, tCurrentLocation);
  });

  test('should return a JSON map containing the proper data', () async {
    final result = tCurrentLocation.toJson();

    final expectedJsonMap = {
      "longitude": 11.2,
      "latitude": 12.3,
    };

    expect(result, expectedJsonMap);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tRouteModel = RouteModel(longitude: 11.2, latitude: 12.3);

  test('should return a valid model when the JSON number is an double',
      () async {
    final Map<String, dynamic> jsonmap =
        json.decode(fixture('current_location.json'));

    final result = RouteModel.fromJson(jsonmap);

    expect(result, tRouteModel);
  });

  test('should return a JSON map containing the proper data', () async {
    final result = tRouteModel.toJson();

    final expectedJsonMap = {
      "longitude": 11.2,
      "latitude": 12.3,
    };

    expect(result, expectedJsonMap);
  });
}

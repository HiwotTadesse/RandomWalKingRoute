import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tRouteModel1 = RouteModel(longitude: 11.2, latitude: 12.3);
  const tRouteModel2 = RouteModel(longitude: 11.2, latitude: 12.3);
  final tRoutesModel = RoutesModel(routesModel: [tRouteModel1, tRouteModel2]);

  test('should return a valid model when the JSON number is an double',
      () async {
    final Map<String, dynamic> jsonmap = json.decode(fixture('routes.json'));

    final result = RoutesModel.fromMap(jsonmap);

    expect(result, equals(tRoutesModel));
  });

  test('should return a JSON map containing the proper data', () async {
    final result = tRoutesModel.toJson();

    final expectedJsonMap = {
      "data": [
        {
          "longitude": 11.2,
          "latitude": 12.3,
        },
        {
          "longitude": 11.2,
          "latitude": 12.3,
        }
      ]
    };

    expect(result, expectedJsonMap);
  });
}

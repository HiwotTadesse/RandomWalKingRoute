import 'package:equatable/equatable.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';

class RoutesModel extends Equatable {
  final List<RouteModel> routesModel;
  const RoutesModel({
    this.routesModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': routesModel.map((x) => x.toJson()).toList(),
    };
  }

  factory RoutesModel.fromMap(Map<String, dynamic> map) {
    return RoutesModel(
      routesModel: List<RouteModel>.from(
          map['data']?.map((x) => RouteModel.fromJson(x))),
    );
  }

  @override
  List<Object> get props => [routesModel];
}

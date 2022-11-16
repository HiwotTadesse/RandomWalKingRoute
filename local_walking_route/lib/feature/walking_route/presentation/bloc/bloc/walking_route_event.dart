import 'package:equatable/equatable.dart';

abstract class WalkingRouteEvent extends Equatable {
  const WalkingRouteEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocationEvent extends WalkingRouteEvent {}

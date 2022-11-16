import 'package:equatable/equatable.dart';

import '../../../domain/entities/CurrentLocation.dart';

abstract class WalkingRouteState extends Equatable {
  const WalkingRouteState();

  @override
  List<Object> get props => [];
}

class WalkingRouteInitial extends WalkingRouteState {}

class WalkingRouteLoading extends WalkingRouteState {}

class WalkingRouteLoaded extends WalkingRouteState {
  final CurrentLocation currentLocation;
  const WalkingRouteLoaded({this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

class WalkingRouteError extends WalkingRouteState {
  final String message;
  const WalkingRouteError({this.message});

  @override
  List<Object> get props => [message];
}

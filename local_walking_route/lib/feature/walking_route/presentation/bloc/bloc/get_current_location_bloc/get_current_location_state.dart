import 'package:equatable/equatable.dart';

import '../../../../domain/entities/current_location.dart';

abstract class CurrentLocationState extends Equatable {
  const CurrentLocationState();

  @override
  List<Object> get props => [];
}

class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationLoading extends CurrentLocationState {}

class CurrentLocationLoaded extends CurrentLocationState {
  final CurrentLocation currentLocation;
  const CurrentLocationLoaded({this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

class CurrentLocationError extends CurrentLocationState {
  final String message;
  const CurrentLocationError({this.message});

  @override
  List<Object> get props => [message];
}

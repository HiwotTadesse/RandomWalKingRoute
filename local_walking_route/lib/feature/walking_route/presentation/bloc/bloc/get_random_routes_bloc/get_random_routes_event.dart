import 'package:equatable/equatable.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';

abstract class RandomRoutesEvent extends Equatable {
  const RandomRoutesEvent();

  @override
  List<Object> get props => [];
}

class GetRandomRoutesEvent extends RandomRoutesEvent {
  final String minute;
  final CurrentLocation currentLocation;

  const GetRandomRoutesEvent({this.minute, this.currentLocation});

  @override
  List<Object> get props => [minute, currentLocation];
}

part of 'walking_route_bloc_bloc.dart';

abstract class WalkingRouteBlocState extends Equatable {
  const WalkingRouteBlocState();

  @override
  List<Object> get props => [];
}

class WalkingRouteBlocInitial extends WalkingRouteBlocState {}

class WalkingRouteBlocLoading extends WalkingRouteBlocState {}

class WalkingRouteBlocLoaded extends WalkingRouteBlocState {
  final CurrentLocation currentLocation;
  const WalkingRouteBlocLoaded({this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

class WalkingRouteBlocError extends WalkingRouteBlocState {
  final String message;
  const WalkingRouteBlocError(this.message);

  @override
  List<Object> get props => [message];
}

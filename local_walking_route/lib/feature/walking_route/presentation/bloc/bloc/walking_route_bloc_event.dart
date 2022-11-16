part of 'walking_route_bloc_bloc.dart';

abstract class WalkingRouteBlocEvent extends Equatable {
  const WalkingRouteBlocEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocationEvent extends WalkingRouteBlocEvent {}

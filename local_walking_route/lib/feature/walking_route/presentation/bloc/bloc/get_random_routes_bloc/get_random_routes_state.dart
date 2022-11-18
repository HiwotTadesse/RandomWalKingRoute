import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/entities/current_location.dart';

abstract class RandomRoutesState extends Equatable {
  const RandomRoutesState();

  @override
  List<Object> get props => [];
}

class RandomRoutesInitial extends RandomRoutesState {}

class RandomRoutesLoading extends RandomRoutesState {}

class RandomRoutesLoaded extends RandomRoutesState {
  final Map<PolylineId, Polyline> setOfRoutes;
  const RandomRoutesLoaded({this.setOfRoutes});

  @override
  List<Object> get props => [setOfRoutes];
}

class RandomRoutesError extends RandomRoutesState {
  final String message;
  const RandomRoutesError({this.message});

  @override
  List<Object> get props => [message];
}

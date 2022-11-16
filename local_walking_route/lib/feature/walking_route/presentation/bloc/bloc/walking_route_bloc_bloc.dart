import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';

import '../../../domain/usecases/get_current_location.dart';

part 'walking_route_bloc_event.dart';
part 'walking_route_bloc_state.dart';

class WalkingRouteBlocBloc
    extends Bloc<WalkingRouteBlocEvent, WalkingRouteBlocState> {
  final GetCurrentLocation getCurrentLocation;

  WalkingRouteBlocBloc({@required GetCurrentLocation location})
      : assert(location != null),
        getCurrentLocation = location,
        super(WalkingRouteBlocInitial());

  @override
  WalkingRouteBlocState get initialState {
    WalkingRouteBlocInitial();
  }

  @override
  Stream<WalkingRouteBlocState> mapEventToState(
    WalkingRouteBlocEvent event,
  ) async* {}
}

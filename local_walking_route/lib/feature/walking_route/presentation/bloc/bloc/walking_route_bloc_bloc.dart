import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_current_location.dart';

part 'walking_route_bloc_event.dart';
part 'walking_route_bloc_state.dart';

class WalkingRouteBlocBloc
    extends Bloc<WalkingRouteBlocEvent, WalkingRouteBlocState> {
  final GetCurrentLocation getCurrentLocationUsecase;

  WalkingRouteBlocBloc({@required GetCurrentLocation location})
      : assert(location != null),
        getCurrentLocationUsecase = location,
        super(WalkingRouteBlocInitial());

  @override
  WalkingRouteBlocState get initialState => WalkingRouteBlocInitial();

  @override
  Stream<WalkingRouteBlocState> mapEventToState(
    WalkingRouteBlocEvent event,
  ) async* {
    if (event is GetCurrentLocationEvent) {
      yield WalkingRouteBlocLoading();
      final failureOrPosition = await getCurrentLocationUsecase(NoParams());
      yield failureOrPosition.fold(
        (failure) => WalkingRouteBlocError(_mapFailureToMessage(failure)),
        (position) => WalkingRouteBlocLoaded(
            currentLocation: CurrentLocation(
                latitude: position.latitude, longitude: position.longitude)),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server Error";
      default:
        return 'Unexpected error';
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/walking_route_state.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_current_location.dart';

class WalkingRouteBloc extends Bloc<WalkingRouteEvent, WalkingRouteState> {
  final GetCurrentLocation getCurrentLocationUsecase;

  WalkingRouteBloc({@required GetCurrentLocation location})
      : assert(location != null),
        getCurrentLocationUsecase = location,
        super(WalkingRouteInitial());

  @override
  WalkingRouteState get initialState => WalkingRouteInitial();

  @override
  Stream<WalkingRouteState> mapEventToState(
    WalkingRouteEvent event,
  ) async* {
    if (event is GetCurrentLocationEvent) {
      yield WalkingRouteLoading();
      final failureOrPosition = await getCurrentLocationUsecase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrPosition);
    }
  }

  Stream<WalkingRouteState> _eitherLoadedOrErrorState(
    Either<Failure, CurrentLocation> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => WalkingRouteError(message: _mapFailureToMessage(failure)),
      (trivia) => WalkingRouteLoaded(currentLocation: trivia),
    );
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

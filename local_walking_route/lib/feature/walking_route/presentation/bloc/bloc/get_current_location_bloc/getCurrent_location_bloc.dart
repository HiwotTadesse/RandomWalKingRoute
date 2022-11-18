import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_current_location_bloc/get_current_location_state.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../domain/usecases/get_current_location.dart';

class CurrentLocationBloc
    extends Bloc<CurrentLocationEvent, CurrentLocationState> {
  final GetCurrentLocation getCurrentLocationUsecase;

  CurrentLocationBloc({@required GetCurrentLocation location})
      : assert(location != null),
        getCurrentLocationUsecase = location,
        super(CurrentLocationInitial());

  @override
  CurrentLocationState get initialState => CurrentLocationInitial();

  @override
  Stream<CurrentLocationState> mapEventToState(
    CurrentLocationEvent event,
  ) async* {
    if (event is GetCurrentLocationEvent) {
      yield CurrentLocationLoading();
      final failureOrPosition = await getCurrentLocationUsecase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrPosition);
    }
  }

  Stream<CurrentLocationState> _eitherLoadedOrErrorState(
    Either<Failure, CurrentLocation> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => CurrentLocationError(message: _mapFailureToMessage(failure)),
      (trivia) => CurrentLocationLoaded(currentLocation: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server Error";
      case ConnectionFailure:
        return "Please check your internet Connection";
      case GpsFailure:
        return "Please turn your GPS on";
      case PermissionFailure:
        return "Please allow location access";
      default:
        return 'Unexpected error';
    }
  }
}

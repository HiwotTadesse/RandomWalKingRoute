import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/core/usecases/usecase.dart';
import 'package:local_walking_route/core/utils/input_converter.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_state.dart';

import '../../../../../../core/error/failures.dart';

class RandomRoutesBloc extends Bloc<RandomRoutesEvent, RandomRoutesState> {
  final GetRandomRoute getRandomRouteUsecase;
  final InputConverter inputConverter;

  RandomRoutesBloc(
      {@required GetRandomRoute routes, @required this.inputConverter})
      : assert(routes != null),
        assert(inputConverter != null),
        getRandomRouteUsecase = routes,
        super(RandomRoutesInitial());

  @override
  RandomRoutesInitial get initialState => RandomRoutesInitial();

  @override
  Stream<RandomRoutesState> mapEventToState(
    RandomRoutesEvent event,
  ) async* {
    if (event is GetRandomRoutesEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.minute);

      yield* inputEither.fold(
        (failure) async* {
          yield const RandomRoutesError(message: "Invalid Input");
        },
        (integer) async* {
          yield RandomRoutesLoading();
          final failureOrPolyLine = await getRandomRouteUsecase(
            Params(minutes: integer, currentLocation: event.currentLocation),
          );

          yield* _eitherLoadedOrErrorState(failureOrPolyLine);
        },
      );
    }
  }

  Stream<RandomRoutesState> _eitherLoadedOrErrorState(
    Either<Failure, RoutesModel> failureOrPolyLine,
  ) async* {
    yield failureOrPolyLine.fold(
      (failure) => RandomRoutesError(message: _mapFailureToMessage(failure)),
      (routes) => RandomRoutesLoaded(setOfRoutes: routes),
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

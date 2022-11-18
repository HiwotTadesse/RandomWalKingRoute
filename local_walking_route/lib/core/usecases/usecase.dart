import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:local_walking_route/core/error/failures.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final int minutes;
  final CurrentLocation currentLocation;

  const Params({this.minutes, this.currentLocation});

  @override
  List<Object> get props => [minutes, currentLocation];
}

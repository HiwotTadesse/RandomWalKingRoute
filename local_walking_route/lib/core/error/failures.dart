import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class ConnectionFailure extends Failure {}

class GpsFailure extends Failure {}

class PermissionFailure extends Failure {}

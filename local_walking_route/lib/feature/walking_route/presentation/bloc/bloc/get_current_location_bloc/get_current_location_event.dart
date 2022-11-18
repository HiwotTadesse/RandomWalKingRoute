import 'package:equatable/equatable.dart';

abstract class CurrentLocationEvent extends Equatable {
  const CurrentLocationEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocationEvent extends CurrentLocationEvent {}

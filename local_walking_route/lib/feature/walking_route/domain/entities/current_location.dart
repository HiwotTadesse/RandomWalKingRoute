import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CurrentLocation extends Equatable {
  final double longitude;
  final double latitude;

  const CurrentLocation({
    @required this.longitude,
    @required this.latitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

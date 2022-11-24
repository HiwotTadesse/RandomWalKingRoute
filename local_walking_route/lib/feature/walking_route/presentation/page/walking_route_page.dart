import 'dart:async';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/feature/walking_route/data/models/route_model.dart';
import 'package:local_walking_route/feature/walking_route/data/models/routes_model.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/current_location.dart';
import 'package:local_walking_route/feature/walking_route/domain/usecases/get_current_location.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_bloc.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_event.dart';
import 'package:local_walking_route/feature/walking_route/presentation/bloc/bloc/get_random_routes_bloc/get_random_routes_state.dart';

import '../../../../injection_container.dart';
import 'package:stream_transform/stream_transform.dart';

class WalkingRouteScreen extends StatefulWidget {
  final CurrentLocation currentLocation;
  const WalkingRouteScreen({Key key, this.currentLocation}) : super(key: key);

  @override
  _WalkingRouteScreenState createState() => _WalkingRouteScreenState();
}

class _WalkingRouteScreenState extends State<WalkingRouteScreen> {
  final TextEditingController controller = TextEditingController();
  GoogleMapController mapController;

  final streamController = StreamController<String>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    final marker = Marker(
      markerId: const MarkerId('place_name'),
      position: LatLng(
          widget.currentLocation.latitude, widget.currentLocation.longitude),
      infoWindow: const InfoWindow(title: "You"),
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });
    streamController.stream
        .debounce(const Duration(milliseconds: 1000))
        .listen((s) => _validateValues(widget.currentLocation));

    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Walking Route'), backgroundColor: Colors.black),
      body: buildBody(context),
    );
  }

  BlocBuilder buildBody(BuildContext context) {
    return BlocBuilder<RandomRoutesBloc, RandomRoutesState>(
        builder: (context, state) {
      if (state is RandomRoutesInitial) {
        return Column(children: [
          _buildInput(),
          const SizedBox(
            height: 10,
          ),
          _buildMapComponent(routesModel: const [])
        ]);
      } else if (state is RandomRoutesLoading) {
        return const Center(
            child: CircularProgressIndicator(
          strokeWidth: 3,
        ));
      } else if (state is RandomRoutesLoaded) {
        return Column(children: [
          _buildInput(),
          const SizedBox(
            height: 10,
          ),
          _buildMapComponent(routesModel: state.setOfRoutes)
        ]);
      } else if (state is RandomRoutesError) {
        return Center(
          child: Text(
            state.message,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildInput() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Length of Time",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Input a number',
                ),
                onChanged: (value) {
                  streamController.add(value);
                },
                onSubmitted: (_) {},
              ),
            ]));
  }

  Widget _buildMapComponent({@required List<RoutesModel> routesModel}) {
    PolylineId id2 = const PolylineId('poly2');
    PolylineId id3 = const PolylineId('poly3');
    PolylineId id4 = const PolylineId('poly4');
    Polyline polyline1 = Polyline(polylineId: id2, points: const [], width: 2);
    Polyline polyline3 = Polyline(polylineId: id3, points: const [], width: 2);
    Polyline polyline4 = Polyline(polylineId: id4, points: const [], width: 2);
    if (routesModel.isNotEmpty) {
      List<LatLng> list = [];
      List<LatLng> list2 = [];
      List<LatLng> list3 = [];

      routesModel[0].routesModel.forEach((RouteModel point) {
        list.add(LatLng(point.latitude, point.longitude));
      });
      routesModel[1].routesModel.forEach((RouteModel point) {
        list2.add(LatLng(point.latitude, point.longitude));
      });
      routesModel[2].routesModel.forEach((RouteModel point) {
        list3.add(LatLng(point.latitude, point.longitude));
      });
      polyline1 = Polyline(
          polylineId: const PolylineId('poly2'),
          color: Colors.red,
          points: list,
          width: 2,
          patterns: [
            PatternItem.dash(8),
            PatternItem.gap(15),
          ],
          jointType: JointType.mitered);
      polyline3 = Polyline(
          polylineId: const PolylineId('poly3'),
          color: Colors.red,
          points: list2,
          width: 2,
          patterns: [
            PatternItem.dash(8),
            PatternItem.gap(15),
          ],
          jointType: JointType.mitered);
      polyline4 = Polyline(
          polylineId: const PolylineId('poly4'),
          color: Colors.red,
          points: list3,
          width: 2,
          patterns: [
            PatternItem.dash(8),
            PatternItem.gap(15),
          ],
          jointType: JointType.mitered);
    }

    return Expanded(
        flex: 2,
        child: GoogleMap(
          padding: const EdgeInsets.all(10),
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.currentLocation.latitude,
                widget.currentLocation.longitude),
            zoom: 55.0,
          ),
          markers: markers.values.toSet(),
          //  polygons: {polygon},
          polylines: {polyline1, polyline3, polyline4},
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ));
  }

  _validateValues(CurrentLocation currentLocation) {
    Future.delayed(Duration(seconds: 5), () {
      if (controller.text.isNotEmpty) {
        BlocProvider.of<RandomRoutesBloc>(context).add(GetRandomRoutesEvent(
            minute: controller.text, currentLocation: currentLocation));
      } else {}
    });
  }
}

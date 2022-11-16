import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_walking_route/feature/walking_route/domain/entities/CurrentLocation.dart';

class WalkingRouteScreen extends StatefulWidget {
  final CurrentLocation currentLocation;
  const WalkingRouteScreen({Key key, this.currentLocation}) : super(key: key);

  @override
  _WalkingRouteScreenState createState() => _WalkingRouteScreenState();
}

class _WalkingRouteScreenState extends State<WalkingRouteScreen> {
  final TextEditingController controller = TextEditingController();
  GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _center = const LatLng(0.0, 0.0);

  @override
  void initState() {
    _center = LatLng(
        widget.currentLocation.latitude, widget.currentLocation.longitude);
    final marker = Marker(
      markerId: const MarkerId('place_name'),
      position: LatLng(
          widget.currentLocation.latitude, widget.currentLocation.longitude),
      infoWindow: const InfoWindow(title: "You"),
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Walking Route'), backgroundColor: Colors.black),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(children: [
      Container(
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Input a number',
                  ),
                  onChanged: (value) {},
                  onSubmitted: (_) {},
                )
              ])),
      const SizedBox(
        height: 10,
      ),
      Expanded(
          flex: 2,
          child: Padding(
              padding: EdgeInsets.all(5),
              child: GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.currentLocation.latitude,
                      widget.currentLocation.longitude),
                  zoom: 15.0,
                ),
                markers: markers.values.toSet(),
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
              )))
    ]);
  }
}

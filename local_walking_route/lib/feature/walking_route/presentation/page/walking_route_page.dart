import 'package:flutter/material.dart';
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
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walking Route'),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: <Widget>[
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Input a number',
                ),
                onChanged: (value) {},
                onSubmitted: (_) {},
              ),
              GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.currentLocation.latitude,
                      widget.currentLocation.longitude),
                  zoom: 10.0,
                ),
                markers: markers,
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
            ])));
  }
}

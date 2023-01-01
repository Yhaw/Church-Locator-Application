import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Routes Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapsRoutesExample(title: 'GMR Demo Home'),
    );
  }
}

class MapsRoutesExample extends StatefulWidget {
  MapsRoutesExample({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MapsRoutesExampleState createState() => _MapsRoutesExampleState();
}

class _MapsRoutesExampleState extends State<MapsRoutesExample> {
  Completer<GoogleMapController> _controller = Completer();

  List<LatLng> points = [
    LatLng(45.82917150748776, 14.63705454546316),
    LatLng(45.833828635680355, 14.636544256202207),
    LatLng(45.851254420031296, 14.624331708344428),
    LatLng(45.84794984187217, 14.605434384742317)
  ];

  MapsRoutes route = new MapsRoutes();
  String googleApiKey = 'YOUR KEY HERE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        polylines: route.routes,
        initialCameraPosition: const CameraPosition(
          zoom: 15.0,
          target: LatLng(45.82917150748776, 14.63705454546316),
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await route.drawRoute(
              points,
              'Test routes',
              Color.fromRGBO(130, 78, 210, 1.0),
              "AIzaSyBOaVD4opnrOdmxpJXGPqE8OIF0stWdQCU",
              travelMode: TravelModes.walking);
        },
      ),
    );
  }
}

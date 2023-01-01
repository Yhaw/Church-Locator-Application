import 'dart:async';
import 'package:church_finder/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

class gpsHome extends StatelessWidget {
  final datta dattta;
  gpsHome({super.key, required this.dattta});
  Completer<GoogleMapController> _controller = Completer();
  MapsRoutes route = new MapsRoutes();
  String googleApiKey = 'AIzaSyBOaVD4opnrOdmxpJXGPqE8OIF0stWdQCU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dattta.name1),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(dattta.lat), double.parse(dattta.lon)),
            zoom: 19.15),
        markers: {
          Marker(
              markerId: MarkerId("Your Location"),
              infoWindow: InfoWindow(
                  title: "Your Location", snippet: "Your Current Location"),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(
                  double.parse(dattta.h_lat), double.parse(dattta.h_lon))),
          Marker(
              markerId: MarkerId(dattta.name1),
              infoWindow: InfoWindow(
                  title: dattta.name1, snippet: "Welcome to " + dattta.name1),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position:
                  LatLng(double.parse(dattta.lat), double.parse(dattta.lon))),
        },
        // polylines: {
        //   Polyline(
        //     polylineId:
        //         PolylineId("Route from your location to " + dattta.name1),
        //     points: [
        //       LatLng(double.parse(dattta.h_lat), double.parse(dattta.h_lon)),
        //       LatLng(double.parse(dattta.lat), double.parse(dattta.lon))
        //     ],
        //     width: 4,
        //   ),
        // },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await route.drawRoute([
      //       LatLng(double.parse(dattta.h_lat), double.parse(dattta.h_lon)),
      //       LatLng(double.parse(dattta.lat), double.parse(dattta.lon))
      //     ], 'Test routes', Color.fromRGBO(130, 78, 210, 1.0),
      //         "AIzaSyBOaVD4opnrOdmxpJXGPqE8OIF0stWdQCU",
      //         travelMode: TravelModes.driving);
      //     print(
      //         "tappoooooooooooooooooooooooooooooooooooooooooooooooooooooooopppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
      //   },
      //   child: const Icon(Icons.directions),
      // ),
    );
  }
}

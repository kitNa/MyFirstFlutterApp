import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';


class MapPolylineScreen extends StatefulWidget {
  const MapPolylineScreen({Key? key}) : super(key: key);

  @override
  _MapPolylineScreenState createState() => _MapPolylineScreenState();
}

class _MapPolylineScreenState extends State<MapPolylineScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  List<Marker> markersList = [];
  final String key = "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM";
  LatLng _center = const LatLng(51.936619, 15.508690);
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey:
  "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM");

  final List<Polyline> polyline = [];

  late PlaceDetails departure;
  late PlaceDetails arrival;

  void onMapCreated(controller) {
    setState(() {
      mapController = _controller as GoogleMapController;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distance on the map"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set.from(markersList),
            polylines: Set.from(polyline),
            onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 7.0,
            ),
          ),
        ],
      ));
    }

  computePath() async {
    LatLng origin = new LatLng(53.416890, 14.532330);
    LatLng end = new LatLng(51.110550, 17.025560);

    List<LatLng>? routeCoords =
    await googleMapPolyline.getCoordinatesWithLocation(
        origin: origin, destination: end, mode: RouteMode.driving
    );

    setState(() {
    polyline.add(Polyline(
        polylineId: const PolylineId('iter'),
        visible: true,
        points: routeCoords as List<LatLng>,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap
    ));
  });
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';


class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({Key? key}) : super(key: key);

  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
 // Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;
  TextEditingController departureController = new TextEditingController();
  TextEditingController arrivalController = new TextEditingController();
  List<Marker> markersList = [];
  final String key = "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM";
  LatLng _center = const LatLng(
      53.416890, 14.532330);
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:
      "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM");
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey:
      "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM");
  final List<Polyline> polyline = [];
  List<LatLng>? routeCoords = [];

  late PlaceDetails departure;
  late PlaceDetails arrival;

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<Null> displayPredictionDeparture(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
          p.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;

      setState(() {
        departure = detail.result;
        departureController.text = detail.result.name;
        Marker marker = Marker(
            markerId: const MarkerId('arrivalMarker'),
            draggable: false,
            infoWindow: const InfoWindow(
              title: "This is where you will arrive",
            ),
            onTap: () {
              //print('this is where you will arrive');
            },
            position: LatLng(lat!, lng!)
        );
        markersList.add(marker);
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 10.0
      )));
    }
  }

  Future<Null> displayPredictionArrival(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
          p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        arrival = detail.result;
        arrivalController.text = detail.result.name;
        Marker marker = Marker(
            markerId: const MarkerId('arrivalMarker'),
            draggable: false,
            infoWindow: const InfoWindow(
              title: "This is where you will arrive",
            ),
            onTap: () {
              //print('this is where you will arrive');
            },
            position: LatLng(lat, lng)
        );
        markersList.add(marker);
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat, lng),
          zoom: 10.0
      )));

      computePath();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set.from(markersList),
            polylines: Set.from(polyline),
          ),
          Positioned(
              top: 10.0,
              right: 15.0,
              left: 15.0,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Enter the departure place?',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  iconSize: 30.0,
                                  onPressed: () {  },
                                )
                            ),
                            controller: departureController,
                            onTap: () async {
                              Prediction? p = await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: key,
                                  mode: Mode.overlay,
                                  language: "en",
                                  components: [
                                    new Component(Component.country, "en")
                                  ]);
                              displayPredictionDeparture(p!);
                            },
                            //onEditingComplete: searchAndNavigate,
                          ),
                        ],
                      )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Enter the arrival place?',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  iconSize: 30.0, onPressed: () {  },
                                )
                            ),
                            controller: arrivalController,
                            onTap: () async {
                              Prediction? p = await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: key,
                                  mode: Mode.overlay,
                                  language: "en",
                                  components: [
                                    new Component(Component.country, "en")
                                  ]);
                              displayPredictionArrival(p!);
                            },
                            //onEditingComplete: searchAndNavigate,
                          ),
                        ],
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  computePath()async{
    LatLng origin = new LatLng(departure.geometry!.location.lat, departure.geometry!.location.lng);
    LatLng end = new LatLng(arrival.geometry!.location.lat, arrival.geometry!.location.lng);

    routeCoords =
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
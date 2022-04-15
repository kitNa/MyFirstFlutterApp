import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  GoogleMapPolyline _googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyC076whTPYV6C0No1Omm0TGweBipVQdWCM");

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  LatLng _mapInitLocation = LatLng(53.421612, 14.541592);

  LatLng _originLocation = LatLng(53.423482, 14.543725);
  LatLng _destinationLocation = LatLng(53.428197, 14.532199);

  bool _loading = false;

  _onMapCreated(GoogleMapController controller) {
    setState(() {
    });
  }

  //Get polyline with Location (latitude and longitude)
  _getPolylinesWithLocation() async {
    _setLoadingMenu(true);
    List<LatLng>? _coordinates =
    await _googleMapPolyline.getCoordinatesWithLocation(
        origin: _originLocation,
        destination: _destinationLocation,
        mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  //Get polyline with Address
  _getPolylinesWithAddress() async {
    _setLoadingMenu(true);
    List<LatLng>? _coordinates =
    await _googleMapPolyline.getPolylineCoordinatesWithAddress(
        origin: '42 Bohaterow Warszawy, Szczecin, NY 70372, Poland',
        destination: '2 Plac Brama Portowa, Szczecin, NY 70001 , Poland',
        mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  _addPolyline(List<LatLng>? _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates!,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
  }

  @override
  Widget build(BuildContext context) {
      return //MaterialApp(
      //home:
      Scaffold(
        appBar: AppBar(
          title: Text('Map Polyline'),
        ),
        body: Container(
          child: LayoutBuilder(
            builder: (context, cont) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 175,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      polylines: Set<Polyline>.of(_polylines.values),
                      initialCameraPosition: CameraPosition(
                        target: _mapInitLocation,
                        zoom: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: _getPolylinesWithLocation,
                              child: Text('Polylines with Location')),
                          ElevatedButton(
                              onPressed: _getPolylinesWithAddress,
                              child: Text('Polylines with Address'))
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _loading
            ? Container(
          color: Colors.black.withOpacity(0.75),
          child: Center(
            child: Text(
              'Loading...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        )
            : Container(),
      //);
     // debugShowCheckedModeBanner: false,
    );
  }
}
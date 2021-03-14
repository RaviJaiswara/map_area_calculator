import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_area_calculator/src/blocs/map_controller.dart';

class MapHome extends StatefulWidget {
  static String id = '/map_home';
  @override
  State<StatefulWidget> createState() {
    return MapHomeState();
  }
}

class MapHomeState extends State<MapHome> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _googleMapController = Completer();
  MapController _mapController = new MapController();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  MapType _mapType = MapType.normal;
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  LatLng _lastMapPosition = _center;
  List<LatLng> polyPoints = [];
  Location _location = Location();

  _onMapCreated(GoogleMapController googleMapController) async {
    _googleMapController.complete(googleMapController);
    final GoogleMapController controller = await _googleMapController.future;
    _location.onLocationChanged.listen((event) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.latitude, event.longitude), zoom: 15),
        ),
      );
    });
  }

  _onCameraMove(CameraPosition cameraPosition) {
    _lastMapPosition = cameraPosition.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _goToCurrentPos() async {
    final GoogleMapController controller = await _googleMapController.future;
    _location.onLocationChanged.listen((event) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.latitude, event.longitude), zoom: 15),
        ),
      );
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
      heroTag: icon.toString(),
    );
  }

  _clearAllMarkers() {
    setState(() {
      _markers.clear();
      _polygons.clear();
      polyPoints.clear();
    });
  }

  Widget snackBarWithTime(String status, String message, int durationInSecond) {
    return SnackBar(
      duration: Duration(seconds: durationInSecond),
      content: Text(message),
    );
  }

  _calculateArea() {
    polyPoints.add(polyPoints[0]);
    print(_mapController.calculatePolygonArea(polyPoints));
    _key.currentState.showSnackBar(snackBarWithTime(
        'success',
        _mapController.calculatePolygonArea(polyPoints).toString() + " Acres",
        10));
  }

  _onTapMarkerAdd(LatLng latLng) {
    setState(() {
      polyPoints.add(latLng);
      _drawPolygon(polyPoints);
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(title: 'title', snippet: 'snippet'),
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (LatLng latLng) {
            print(latLng);
            print(latLng.toString());
          },
        ),
      );
    });
  }

  _drawPolygon(List<LatLng> listLatLng) {
    setState(() {
      _polygons.add(Polygon(
          polygonId: PolygonId('123'),
          points: listLatLng,
          fillColor: Colors.transparent,
          strokeColor: Colors.greenAccent));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: _mapType,
            markers: _markers,
            polygons: _polygons,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            onTap: (LatLng latLng) {
              _onTapMarkerAdd(latLng);
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(19.2215, 73.1645), zoom: 15.0),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  button(_onMapTypeButtonPressed, Icons.map),
                  SizedBox(height: 16.0),
                  button(_goToCurrentPos, Icons.location_searching_sharp),
                  SizedBox(height: 16.0),
                  button(_clearAllMarkers, Icons.delete),
                  SizedBox(height: 16.0),
                  button(_calculateArea, Icons.calculate),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

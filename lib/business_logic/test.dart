import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:buniess_case/business_logic/screens/home/myMap/Api.dart';
import 'package:permission_handler/permission_handler.dart' as p;
import 'package:geolocator_platform_interface/src/enums/location_service.dart' as geo;


class MapScreen extends StatefulWidget {
  final double lat;
  final double long;

  const MapScreen({required this.lat, required this.long});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Raw coordinates got from OpenRouteService
  List<dynamic> listOfPoints = [];

  // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
  List<LatLng> points = [];

  // User's current location
  LatLng? currentLocation;

  MapController mapController = MapController();

  StreamSubscription<Position>? _positionStreamSubscription;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Marker marker = Marker(
    point: LatLng(0, 0),
    width: 80,
    height: 80,
    builder: (context) => Container(
      child: Image.asset('assets/images/locate.png'),
    ),
  );

  // Method to consume the OpenRouteService API
  Future<void> getCoordinates() async {
    // Requesting for openrouteservice api
    var url = Uri.parse(getRouteUrl(
      "${currentLocation?.longitude},${currentLocation?.latitude}",
      '${widget.long},${widget.lat}',
    ).toString());

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      listOfPoints = data['features'][0]['geometry']['coordinates'] as List<dynamic>;

      points = listOfPoints
          .map(
            (p) => LatLng(
          (p[1] as double).toDouble(),
          (p[0] as double).toDouble(),
        ),
      )
          .toList();

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    checkLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }


  Future<void> checkLocationPermission() async {
    final p.PermissionStatus permissionStatus = await p.Permission.location.request();
    if (permissionStatus == p.PermissionStatus.granted) {
      activateLocationUpdates();
    } else if (permissionStatus == p.PermissionStatus.denied) {
      final p.ServiceStatus serviceStatus =
      await p.Permission.locationWhenInUse.serviceStatus;
      if (serviceStatus == p.ServiceStatus.disabled ) {
        // Location service is disabled or denied, show an error message to the user
      } else {
        activateLocationUpdates();
      }
    }
  }

  void activateLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings

    ).listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        // Move the map to the user's current location
      });
      // Update the user's current location on the map

      setState(() {
        marker = Marker(
          point: currentLocation!,
          width: 80,
          height: 80,
          builder: (context) => Container(
            child: Image.asset('assets/images/locate.png'),
          ),
        );
        // Call the API to get the coordinates only when user's current location is not null
        if (currentLocation !=null) {
          getCoordinates();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentLocation ?? LatLng(widget.lat, widget.long),
              zoom: 13.0,
            ),
              children: [
                // Layer that adds the map
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                // Layer that adds points the map
                MarkerLayer(
                  markers: [
                    // First Marker
                    Marker(
                      point: currentLocation!,
                      width: 80,
                      height: 80,
                      builder: (context) => StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            child: Image.asset('assets/images/locate.png'),
                          );
                        },
                      ),
                    )
                    ,
                    // Second Marker
                    Marker(
                      point: LatLng(6.125231015668568, 1.2160116523406839),
                      width: 80, // Add the missing value
                      height: 80,
                      builder: (context) => IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on),
                        color: Colors.red,
                        iconSize: 45,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                        points: points, color: Colors.black, strokeWidth: 5),
                  ],
                ),
              ],
          ),
          Positioned(
            top: 50,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

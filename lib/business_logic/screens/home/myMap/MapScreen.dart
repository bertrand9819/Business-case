import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:buniess_case/business_logic/screens/home/myMap/Api.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? long;

  const MapScreen({required this.long, required this.lat});

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

  StreamSubscription<Position> ? _positionStreamSubscription;
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
      '1.2160116523406839,6.125231015668568',
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
  Future<bool> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _positionStreamSubscription = Geolocator.getPositionStream(
       // update every 10 meters
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
      });
    });

  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Position>(
        stream: Geolocator.getPositionStream(
            locationSettings: locationSettings // update every 10 meters
        ),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          currentLocation = LatLng(
            snapshot.data!.latitude,
            snapshot.data!.longitude,
          );

          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              zoom: 15,
              center: currentLocation,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (currentLocation != null) {
            await getCoordinates();
          }

        },
        child: const Icon(Icons.directions),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

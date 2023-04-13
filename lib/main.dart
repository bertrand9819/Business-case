import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buniess_case/business_logic/screens/splashSceen.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool ?_serviceEnabled;
  LocationPermission ? _permissionGranted;

  @override
  void initState() {
    super.initState();
    checkLocation();
  }

  Future<void> checkLocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await Geolocator.openLocationSettings();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await Geolocator.checkPermission();
    if (_permissionGranted == LocationPermission.denied) {
      _permissionGranted = await Geolocator.requestPermission();
      if (_permissionGranted != LocationPermission.whileInUse &&
          _permissionGranted != LocationPermission.always) {
        return;
      }
    }

    if (_serviceEnabled! && _permissionGranted != LocationPermission.denied) {
      // L'utilisateur a activé la géolocalisation
      // Mettez ici votre code pour récupérer la position de l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onboarding Concept',
      home: Builder(
        builder: (BuildContext context) {
          return SplashScreen();
        },
      ),
    );
  }
}

void main() => runApp(App());

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pilasconelhueco/home/homepage.dart';

import '../screens/huecosbaches.dart';

class LocationPermissionUtil extends StatefulWidget {
  final Widget child;

  const LocationPermissionUtil({Key? key, required this.child}) : super(key: key);

  @override
  _LocationPermissionUtilState createState() => _LocationPermissionUtilState();
}

class _LocationPermissionUtilState extends State<LocationPermissionUtil> {
  late OverlayEntry _overlayEntry;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      print('Permiso de ubicación concedido.');
      _navigateToNextScreen();
    } else {
      print('Permiso de ubicación denegado.');
      setState(() {
        _permissionDenied = true;
      });
    }
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ReportPotholesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _showPermissionDeniedOverlay(context);
      });
    }

    return widget.child;
  }

  void _showPermissionDeniedOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Text(
                'Permiso de ubicación denegado.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry);
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    super.dispose();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationPermissionUtil(
        child: LocationPermissionScreen(),
      ),
    );
  }
}

class LocationPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de permiso de ubicación'),
      ),
      body: Center(
        child: Text('Solicitando permiso de ubicación...'),
      ),
    );
  }
}

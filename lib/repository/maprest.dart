import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pilasconelhueco/shared/keys.dart';

class RestMapRepository {


  static Future<LatLng> getCoordinates(String address, GoogleMapController mapController) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$GOOGLEAPIKEY'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("status code: ${response.statusCode} - data: ${data['status']} - ${data['results']}");
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        var latLng = LatLng(location['lat'] as double, location['lng'] as double);
        mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 15,
        ),
        ));

        return latLng;
      } else {
        throw Exception('No se pudieron obtener las coordenadas');
      }
    } else {
      throw Exception('Error en la solicitud de geocodificación');
    }
  }


  static Future<void> getAddressFromLatLng(LatLng latLng, Function(String) setAddress) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        setAddress(address);
      }
    } catch (e) {
      print('Error: $e');
    }
  }



}
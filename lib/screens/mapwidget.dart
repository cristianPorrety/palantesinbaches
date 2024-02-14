

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pilasconelhueco/repository/maprest.dart';
import 'package:pilasconelhueco/shared/styles.dart';

class MapFragment extends StatefulWidget {
  late String Function() directionTyped;
  late Function(String) setAddress;
  
  MapFragment({super.key, required this.directionTyped, required this.setAddress});

  
  @override
  // ignore: library_private_types_in_public_api
  _MapFragmentState createState() {
    // ignore: no_logic_in_create_state
    return _MapFragmentState(directionTyped: directionTyped, setAddress: setAddress);
  }

}


class _MapFragmentState extends State<MapFragment> {
  static const double defaultZoom = 13.0;
  Set<Marker> markers = Set();
  static const LatLng staMarta = LatLng(11.239912, -74.194023);
  late GoogleMapController mapController;
  late String Function()  directionTyped;
  late Function(String) setAddress;


  _MapFragmentState({required this.directionTyped, required this.setAddress});


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsPalet.itemColor)
          ),
          height: 300,
          child: GoogleMap(
            onTap: (argument) {
              _addMarker(argument);
              //RestMapRepository.getAddressFromLatLng(argument, setAddress);
            },
            onMapCreated: _onMapCreated,
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: staMarta, zoom: defaultZoom),
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () => RestMapRepository.getCoordinates(directionTyped(), mapController),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: ColorsPalet.backgroundColor,
                      border: Border.all(
                        color: ColorsPalet.primaryColor
                      )
                    ),
                    height: 40,
                    width: 140,
                    child: Center(child: Text("Buscar", style: TextStyle(color: ColorsPalet.primaryColor, fontWeight: FontWeight.bold),)),
                  ),
                ),
                const SizedBox(width: 2,)
            ],
          ),
        ),
      ],
    );
  }


  void _addMarker(LatLng latLng) {
    setState(() {
      markers.clear();
      print("mapaaaa");
      markers.add(Marker(
        markerId: MarkerId('selected-location'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet: 'Lat: ${latLng.latitude}, Lng: ${latLng.longitude}',
        ),
      ));
    });
  }

}
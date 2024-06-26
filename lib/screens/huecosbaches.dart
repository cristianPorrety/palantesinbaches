import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/bloc/motive_bloc.dart';
import 'package:pilasconelhueco/bloc/user_bloc.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/repository/dataservice.dart';
import 'package:pilasconelhueco/repository/maprest.dart';
import 'package:pilasconelhueco/screens/huecosbaches/camerautils.dart';
import 'package:pilasconelhueco/shared/labels.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import 'package:pilasconelhueco/util/alerts.dart';
import 'package:pilasconelhueco/util/device_info.dart';
import 'package:uuid/uuid.dart';

class ReportPotholesScreen extends StatefulWidget {
  const ReportPotholesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportPotholesScreenState createState() {
    return _ReportPotholesScreenState();
  }
}

class _ReportPotholesScreenState extends State<ReportPotholesScreen> {
  late OverlayEntry _overlayEntry;
  bool _permissionDenied = false;
  static const double defaultZoom = 13.0;
  Set<Marker> markers = {};
  static const LatLng staMarta = LatLng(11.239912, -74.194023);
  late GoogleMapController mapController;
  final TextEditingController _directionFieldController =
      TextEditingController();
  final TextEditingController _obsercationFieldController =
      TextEditingController();
  final TextEditingController _nameAndLastNameFieldController =
      TextEditingController();
  final TextEditingController _countrycodeFieldController =
      TextEditingController(text: '57');
  final TextEditingController _cellphoneFieldController =
      TextEditingController();
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _anotherMotiveFieldController = TextEditingController();
  String emailText = "";
  String cellphoneText = "";
  String nombreText = "";
  late List<Widget Function()> widgets;
  LatLng? coordinates;
  bool isEmpty = false;
  bool gpsEnabled = false;
  int index = 0;
  List<XFile> filesSelected = [];
  bool _isLoading = false;
  ConfirmDataModel? datamodel;
  String? selectedOption = null;
  late LatLng currentLocation;
  var textInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\sáéíóúÁÉÍÓÚüÜ]'));

  void finalize(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    datamodel?.deviceFamily = DeviceInfoManager.getDeviceFamily();
    var deviceId = DeviceInfoManager.getDeviceId();
    deviceId.then(
      (value) {
        print("el device id: $value");
        datamodel?.deviceId = value;
        datamodel?.latitude = currentLocation.latitude.toString();
        datamodel?.longitude = currentLocation.longitude.toString();
        print(
            "current report latitude: ${datamodel!.currentReportLatitude.toString()} - current report longitude ${datamodel!.currentReportLongitude.toString()}");
        print(
            "current user latitude: ${datamodel!.latitude.toString()} - current user longitude ${datamodel!.longitude.toString()}");
        print(
            "conectivity status before post: ${getit<ConectivityCubit>().state.connected!}");
        getit<DataService>().postReport(datamodel!).then((status) {
          setState(() {
            _isLoading = false;
          });
          _Dialog_finalizar(context, status);
        });
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String getTextOfDirection() {
    print("hellooooooo");
    return _directionFieldController.text;
  }

  void setDirectionInputState(String direction) {
    setState(() {
      print(direction);
      _directionFieldController.text = direction;
    });
  }

  void setLatLng(LatLng coordinates) {
    setState(() {
      print(coordinates);
      this.coordinates = coordinates;
    });
  }

  void addFile(XFile file) {
    setState(() {
      filesSelected.add(file);
    });
  }

  void setConfirmData(ConfirmDataModel dataModel) {
    setState(() {
      datamodel = datamodel;
    });
  }

  void addMultipleFiles(List<XFile> files) {
    setState(() {
      filesSelected.addAll(files);
    });
  }

  void deleteFile(int index) {
    setState(() {
      filesSelected.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the variable in the initState method
    _requestLocationPermission();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("on net change test: $result");
      getit<ConectivityCubit>().isInternetConnected(result);
    });
    widgets = [_mapWithDirectionBody, _moreData, _confirmData];
    nombreText = getit<UsuarioCubit>().state.nombre ?? "";
    emailText = getit<UsuarioCubit>().state.correoElectronico ?? "";
    cellphoneText = getit<UsuarioCubit>().state.celular ?? "";
    //_nameAndLastNameFieldController.text = usuarioCubit.state.nombre ?? "";
  }

  Widget _getContentToButton() {
    if (_isLoading) {
      return CircularProgressIndicator(
        color: ColorsPalet.backgroundColor,
      );
    }
    return Text(
      (index < widgets.length - 1) ? "Continuar" : "Finalizar",
      style: TextStyle(
          fontSize: 25,
          color: ColorsPalet.backgroundColor,
          fontWeight: FontWeight.bold),
    );
  }

  void _getCurrentLocationAndMark() async {
    LatLng? currentLocationObtained =
        await RestMapRepository.getCurrentLocation();
    if (currentLocationObtained != null) {
      _addMarker(currentLocationObtained);
      setAddressByLatIng(currentLocationObtained);
      setLatLng(currentLocationObtained);
      setState(() {
        currentLocation = currentLocationObtained;
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocationObtained,
            zoom: 15,
          ),
        ),
      );
    }
  }

  // Street, sublocality, subadministrative area, administrative area, country
  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      print('Permiso de ubicación concedido.');
      setState(() {
        gpsEnabled = true;
      });
      _getCurrentLocationAndMark(); // Call this method when permission is granted
    } else if (status == PermissionStatus.denied) {
      setState(() {
        gpsEnabled = false;
      });
      print('Permiso de ubicación denegado.');
      setState(() {
        _permissionDenied = true;
      });
      _showPermissionDeniedToast(context);
    } else {
      print('Permiso de ubicación denegado permanentemente.');
      setState(() {
        gpsEnabled = false;
      });
      setState(() {
        _permissionDenied = true;
      });
      _showPermanentDeniedToast(context);
    }
  }

  void _showPermissionDeniedToast(BuildContext context) {
    ToastManager2.showPersistentToast(context,
        "Se rechazó el permiso para acceder a la ubicación. Por favor, acepte los permisos necesarios de la aplicación.");
  }

  void _showPermanentDeniedToast(BuildContext context) {
    ToastManager2.showPersistentToast(context,
        "Se rechazó el permiso para acceder a la ubicación. Por favor, acepte los permisos necesarios de la aplicación.");
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: ColorsPalet.primaryColor,
          elevation: 1,
          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(30),
          //     bottomRight: Radius.circular(30),
          //   ),
          // ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            MainPageText.hoolTitle,
            style: TextStyle(
                color: ColorsPalet.backgroundColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: (index == 0)
          ? _mapWithDirectionBody()
          : Column(
              children: [
                Expanded(
                  flex: 8,
                  child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: widgets[index]()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (index > 0)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 8.0),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (index > 0) {
                                                  index--;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.arrow_back),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 30,
                                        ),
                                  SizedBox(
                                    width: 150,
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _ButtonForm(),
                                        SizedBox(
                                          height: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 3,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: (i == index)
                                                          ? ColorsPalet
                                                              .primaryColor
                                                          : ColorsPalet
                                                              .itemColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        /*Container(
                          width: 53,
                          height: 53,
                          child: Center(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widgets.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                      width: 23,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (i == index) ? ColorsPalet.primaryColor : ColorsPalet.itemColor,
                                      ),
                                    ),
                                );
                              },
                            ),
                          ),
                  )*/
                      ]),
                ),
              ],
            ),
    );
  }

  Widget _ButtonForm() {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            {
              if (_directionFieldController.text.isEmpty ||
                  _obsercationFieldController.text.isEmpty) {
                ToastManager.showToast(context, "faltan agregar campos.");
              } else if (coordinates == null) {
                ToastManager.showToast(
                    context, "no se ha seleccionado un sitio en especifico.");
              } else {
                setState(() {
                  ConfirmDataModel dataModelFirstScreen = ConfirmDataModel();
                  dataModelFirstScreen.address = _directionFieldController.text;
                  dataModelFirstScreen.observation =
                      _obsercationFieldController.text;
                  dataModelFirstScreen.currentReportLatitude =
                      coordinates!.latitude.toString();
                  dataModelFirstScreen.currentReportLongitude =
                      coordinates!.longitude.toString();
                  datamodel = dataModelFirstScreen;
                  index++;
                });
              }
            }
          case 1:
            {
              if (_nameAndLastNameFieldController.text.isEmpty ||
                  _countrycodeFieldController.text.isEmpty ||
                  _cellphoneFieldController.text.isEmpty ||
                  _emailFieldController.text.isEmpty ||
                  filesSelected.isEmpty ||
                  _cellphoneFieldController.text.length != 10 ||
                  !_isValidEmail(_emailFieldController.text)) {
                ToastManager.showToast(context,
                    "Los datos ingresados no son correctos, o están incompletos");
              } else if (selectedOption == null) {
                ToastManager.showToast(
                    context, "Por favor seleccione una motivo de daño. ");
              } else {
                setState(() {
                  ConfirmDataModel dataModelSecondScreen = ConfirmDataModel();
                  dataModelSecondScreen.address = datamodel!.address;
                  dataModelSecondScreen.observation = datamodel!.observation;
                  dataModelSecondScreen.name =
                      _nameAndLastNameFieldController.text;
                  dataModelSecondScreen.cellphone =
                      "+${_countrycodeFieldController.text} ${_cellphoneFieldController.text}";
                  dataModelSecondScreen.currentReportLatitude =
                      coordinates!.latitude.toString();
                  dataModelSecondScreen.currentReportLongitude =
                      coordinates!.longitude.toString();
                  dataModelSecondScreen.email = _emailFieldController.text;
                  dataModelSecondScreen.evidences = filesSelected;
                  dataModelSecondScreen.motive = selectedOption;
                  dataModelSecondScreen.reportDate = DateTime.now().toString();
                  String uuid = Uuid().v4().toUpperCase();
                  dataModelSecondScreen.reportId =
                      "RE${uuid.substring(uuid.length - 11)}";
                  datamodel = dataModelSecondScreen;
                  index++;
                });
              }
            }
          case 2:
            {
              if (filesSelected.isEmpty) {
                ToastManager.showToast(
                    context, "Debe agregar al menos un evidencia.");
              } else {
                //TODO
                finalize(context);
              }
            }
        }
      },
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
            color: ColorsPalet.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(child: GestureDetector(child: _getContentToButton())),
      ),
    );
  }

  void _Dialog_finalizar(BuildContext context, String status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(),
                child: Image.asset(
                  'assets/img/fi_check-circle.png',
                  width: 60.0,
                  height: 60.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (status != "LOCATION_REPORT_NOT_VALID")
                          ? DialogFinalizarText.reportcompleted
                          : "Atencion: Daño fuera del área de cobertura. Por favor revise.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsPalet.primaryColor,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    status == "SUCCESS"
                        ? Center(
                            child: Text(
                              "Número de reporte: ${datamodel!.reportId}",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (status == "LOCATION_REPORT_NOT_VALID") {
                  setState(() {
                    index = 0;
                  });
                  Navigator.pop(context);
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsPalet.primaryColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // Color del texto
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  Future<void> setAddressByLatIng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    // Street, sublocality, subadministrative area, administrative area, country
    setDirectionInputState(
        "${placemarks[0].street} ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}");
  }

  Widget MapFragment() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: ColorsPalet.itemColor)),
      child: GoogleMap(
        onTap: (argument) {
          _addMarker(argument);
          print(argument);
          setLatLng(argument);
          setAddressByLatIng(argument);
          //RestMapRepository.getAddressFromLatLng(argument, setAddress);
        },
        onMapCreated: _onMapCreated,
        markers: markers,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: (coordinates == null) ? staMarta : coordinates!, zoom: defaultZoom),
      ),
    );
  }

  Widget _mapWithDirectionBody() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: (gpsEnabled)
              ? MapFragment()
              : SizedBox(
                  child: Center(
                      child: Text(
                    "Debe activar el permiso de ubicación",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: ColorsPalet.primaryColor),
                  )),
                ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.5, // Tamaño inicial del sheet
          minChildSize: 0.5, // Tamaño mínimo al hacer swipe hacia abajo
          maxChildSize: 0.8, // Tamaño máximo al hacer swipe hacia arriba
          builder: (context, scrollController) {
            return bottomModalSheet();
          },
        ),
      ],
    );
  }

  Widget bottomModalSheet() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Column(
            children: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(PotholesScreenText.titleForm,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    PotholesScreenText.directionField,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _DirectionTextField(),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  /*GestureDetector(
                    onTap: () {
                      if (_directionFieldController.text.isEmpty) {
                        ToastManager.showToast(context,
                            "El campo de dirección no puede estar vacío.");
                      } else {
                        RestMapRepository.getCoordinates(
                            _directionFieldController.text,
                            mapController,
                            context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        //margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: ColorsPalet.backgroundColor,
                            border: Border.all(color: ColorsPalet.primaryColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Icon(
                              Icons.search,
                              color: ColorsPalet.primaryColor,
                              size: 33,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    child: Text(
                      PotholesScreenText.observationField,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                _TextAreaField(),
              ],
            ),
          ),
          _ButtonForm()
        ],
      ),
    );
  }

  Widget _moreData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(PotholesScreenText.moreDataTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.nameAndLastNameField,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          _NameLastNameTextField(),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.phonefield,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          _CellPhoneField(),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.emailField,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          _EmailTextField(),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.motiveField,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          _MotiveTextField(),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.evidenceOptions,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          _rowsOptions(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Container(
              height: filesSelected.length * 45,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: getPhotosTakedListTile(),
            ),
          )
        ],
      ),
    );
  }

  Widget _confirmData() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.title,
                style: TextStyle(
                    color: ColorsPalet.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.nameLabel,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.name!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.cellphone,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.cellphone!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.email,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.email!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.damageUbi,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.address!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.damageMotive,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.motive!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.reportDate,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(datamodel!.reportDate!,
                style: TextStyle(
                    color: ColorsPalet.itemColorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(ConfirmDataLabels.evidence,
                style: TextStyle(
                    color: ColorsPalet.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: ConfirmDataLabels.important,
                    style: TextStyle(
                      color: ColorsPalet.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: " " + ConfirmDataLabels.importantNote,
                    style: TextStyle(
                      color: ColorsPalet.itemColorBlack,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Container(
              height: filesSelected.length * 45,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: getPhotosTakedListTile(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DirectionTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
          color: ColorsPalet.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 0),
          ]),
      child: Column(
        children: [
          TextField(
            controller: _directionFieldController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_directionFieldController.text.isEmpty) {
                      ToastManager.showToast(context,
                          "El campo de dirección no puede estar vacío.");
                    } else {
                      RestMapRepository.getCoordinates(
                          _directionFieldController.text,
                          mapController,
                          context);
                    }
                  },
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsPalet.primaryColor)),
                errorText: (isEmpty) ? 'Credenciales Incorrectas' : null,
                border: const OutlineInputBorder()),
            cursorColor: ColorsPalet.primaryColor,
          ),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.directionFieldDesc,
                style: TextStyle(fontSize: 11),
              )),
        ],
      ),
    );
  }

  Widget _TextAreaField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
          color: ColorsPalet.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 0),
          ]),
      child: Column(
        children: [
          TextField(
            maxLines: 2,
            controller: _obsercationFieldController,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsPalet.primaryColor)),
                errorText: (isEmpty) ? 'Credenciales Incorrectas' : null,
                border: const OutlineInputBorder()),
            cursorColor: ColorsPalet.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget getPhotosTakedListTile() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: filesSelected.length,
      itemBuilder: (context, i) {
        print(filesSelected[i].path);
        return Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 7),
          child: IntrinsicWidth(
            child: Container(
              width: 23,
              height: 27,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorsPalet.backgroundColor,
                  border: Border.all(color: ColorsPalet.primaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(filesSelected[i]
                      .path
                      .substring(filesSelected[i].path.length - 8)),
                  IconButton(
                    onPressed: () {
                      deleteFile(i);
                    },
                    icon: Icon(Icons.close),
                    iconSize: 15,
                    color: ColorsPalet.primaryColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 4,
      backgroundColor: ColorsPalet.backgroundColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              //Evidencia video
              /*

            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  CameraUtils.recordVideo(context, addFile, filesSelected);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: ColorsPalet.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(Icons.video_call,
                            color: ColorsPalet.backgroundColor, size: 40),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "VIDEO",
                          style: TextStyle(
                              color: ColorsPalet.backgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),*/
              GestureDetector(
                onTap: () {
                  if (filesSelected.length < 2) {
                    Navigator.pop(context);
                    CameraUtils.capturePhoto(addFile, filesSelected);
                  } else {
                    Navigator.pop(context);
                    ToastManager.showToastOnTop(
                        context, "Ya ha llegado al maximo de evidencias.");
                  }
                },
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: ColorsPalet.primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: [
                      Icon(Icons.photo,
                          color: ColorsPalet.backgroundColor, size: 40),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "FOTO",
                        style: TextStyle(
                            color: ColorsPalet.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _NameLastNameTextField() {
    _nameAndLastNameFieldController.text = nombreText;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
          color: ColorsPalet.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 0),
          ]),
      child: Column(
        children: [
          TextField(
            controller: _nameAndLastNameFieldController,
            inputFormatters: [textInputFormatter],
            onChanged: (value) => setState(() => nombreText = value),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsPalet.primaryColor)),
                errorText: (isEmpty) ? 'Credenciales Incorrectas' : null,
                border: const OutlineInputBorder()),
            cursorColor: ColorsPalet.primaryColor,
          ),
          SizedBox(
              width: double.infinity,
              child: Text(
                PotholesScreenText.nameAndLastNameFieldDesc,
                style: TextStyle(fontSize: 11),
              )),
        ],
      ),
    );
  }

  Widget _CellPhoneField() {
    _cellphoneFieldController.text = cellphoneText;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
          color: ColorsPalet.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 0),
          ]),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: TextField(
                controller: _countrycodeFieldController,
                onChanged: (_) {
                  setState(() {});
                },
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsPalet.primaryColor)),
                    errorText: (isEmpty) ? 'Credenciales Incorrectas' : null,
                    border: const OutlineInputBorder()),
                cursorColor: ColorsPalet.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: TextField(
                controller: _cellphoneFieldController,
                onChanged: (cell) {
                  setState(() {
                    cellphoneText = cell;
                  });
                },
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsPalet.primaryColor)),
                    errorText: (_cellphoneFieldController.text.isNotEmpty &&
                            _cellphoneFieldController.text.length != 10)
                        ? ''
                        : null,
                    border: const OutlineInputBorder()),
                cursorColor: ColorsPalet.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _EmailTextField() {
    _emailFieldController.text = emailText;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: ColorsPalet.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 0),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _emailFieldController,
            onChanged: (text) {
              setState(() {
                emailText = text;
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorsPalet.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red), // Borde rojo cuando hay error
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey), // Borde gris cuando no hay error
              ),
              errorText: (_emailFieldController.text.isNotEmpty &&
                      !_isValidEmail(_emailFieldController.text))
                  ? 'Formato de correo no válido'
                  : null, // Usamos null para no mostrar el mensaje de error cuando no hay error
              border: const OutlineInputBorder(),
            ),
            cursorColor: ColorsPalet.primaryColor,
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String input) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(input);
  }

  Widget _MotiveTextField() {
    return GestureDetector(
      onTap: () async {
        String? selected = await getModalScreen();
        if (selected == "OTROS") {
          selected = await getOtherText();
          setState(() {
            selected = selected!.isEmpty ? null : selected;
          });
        }
        setState(() {
          selectedOption = selected;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsPalet.primaryColor),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Se almacena la opción se leccionada
              Text(selectedOption == null
                  ? "Selecciona una opción...."
                  : selectedOption!),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getModalScreen() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opciones',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsPalet.primaryColor)),
          content: SizedBox(
            width: 300,
            height: 400,
            child: CupertinoScrollbar(
              child: ListView.builder(
                itemCount: getit<MotivesCubit>().state.length,
                itemBuilder: (context, index) {
                  print("motive: ${getit<MotivesCubit>().state[index]}");
                  return ListTile(
                    title: Text(getit<MotivesCubit>().state[index].name!),
                    onTap: () {
                      Navigator.pop(
                          context, getit<MotivesCubit>().state[index].name!);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> getOtherText() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OTRO MOTIVO',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsPalet.primaryColor)),
          content: SizedBox(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _anotherMotiveFieldController,
                  decoration: const InputDecoration(
                    hintText: "Escribe otro motivo",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                      Navigator.pop(context, _anotherMotiveFieldController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsPalet.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white, // Color del texto
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      },
    );
  }

  Widget _rowsOptions() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (filesSelected.length < 2) {
                _openModal(context);
              } else {
                ToastManager.showToast(
                    context, "Ya ha llegado al maximo de evidencias.");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ColorsPalet.backgroundColor,
                  border: Border.all(
                      color: (filesSelected.length < 2)
                          ? ColorsPalet.primaryColor
                          : Colors.grey)),
              height: 40,
              width: 140,
              child: Center(
                  child: Text(
                "Tomar Evidencia",
                style: TextStyle(
                    color: (filesSelected.length < 2)
                        ? ColorsPalet.primaryColor
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (filesSelected.length < 2) {
                CameraUtils.getMedia(addMultipleFiles, filesSelected, context);
              } else {
                ToastManager.showToast(
                    context, "Ya ha llegado al maximo de evidencias.");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ColorsPalet.backgroundColor,
                  border: Border.all(
                      color: (filesSelected.length < 2)
                          ? ColorsPalet.primaryColor
                          : Colors.grey)),
              height: 40,
              width: 140,
              child: Center(
                  child: Text("Galeria",
                      style: TextStyle(
                          color: (filesSelected.length < 2)
                              ? ColorsPalet.primaryColor
                              : Colors.grey,
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }
}

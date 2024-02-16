import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/screens/huecosbaches/camerautils.dart';
import 'package:pilasconelhueco/screens/mapwidget.dart';
import 'package:pilasconelhueco/shared/labels.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import 'package:pilasconelhueco/util/inheritedwiidget.dart';

class DirectionBody extends StatefulWidget {
  @override
  _DirectionBodyState createState() {
    return _DirectionBodyState();
  }
}

class _DirectionBodyState extends State<DirectionBody> {
  final TextEditingController _directionFieldController =
      TextEditingController();
  final TextEditingController _obsercationFieldController =
      TextEditingController();
  bool isEmpty = false;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(PotholesScreenText.titleForm,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    PotholesScreenText.directionField,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              _DirectionTextField(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: MapFragment(
              directionTyped: getTextOfDirection,
              setAddress: setDirectionInputState),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: Text(
                    PotholesScreenText.observationField,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              _TextAreaField(),
            ],
          ),
        ),
      ],
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
            maxLines: 3,
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
}

class MoreDataScreen extends StatefulWidget {
  const MoreDataScreen({super.key});

  @override
  _MoreDataScreenState createState() {
    return _MoreDataScreenState();
  }
}

class _MoreDataScreenState extends State<MoreDataScreen> {
  final TextEditingController _nameAndLastNameFieldController =
      TextEditingController();
  final TextEditingController _obsercationFieldController =
      TextEditingController();
  final TextEditingController _countrycodeFieldController =
      TextEditingController();
  final TextEditingController _cellphoneFieldController =
      TextEditingController();
  final TextEditingController _emailFieldController = TextEditingController();
  String selectedValue = "USA";
  bool isEmpty = false;
  late Function(int) deleteFile;
  late Function(File) addFile;
  late Function(List<File>) addMultipleFiles;
  late List<File> selectedFiles;
  late ConfirmDataModel? confirmDataModel;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  @override
  void didChangeDependencies() {
    deleteFile = ThreeScreensInheritedWidget.of(context).deleteFile;
    addFile = ThreeScreensInheritedWidget.of(context).addFile;
    addMultipleFiles = ThreeScreensInheritedWidget.of(context).addMultipleFiles;
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                PotholesScreenText.observationField,
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
              height: selectedFiles.length * 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: getPhotosTakedListTile(),
            ),
          )
        ],
      ),
    );
  }

  Widget getPhotosTakedListTile() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: selectedFiles.length,
      itemBuilder: (context, i) {
        print(selectedFiles[i].path);
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
                  Text(selectedFiles[i]
                      .path
                      .substring(selectedFiles[i].path.length - 8)),
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  CameraUtils.recordVideo(context, addFile, selectedFiles);
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  CameraUtils.capturePhoto(addFile, selectedFiles);
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
                maxLength: 10,
                keyboardType: TextInputType.phone,
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
        ],
      ),
    );
  }

  Widget _EmailTextField() {
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
            controller: _emailFieldController,
            keyboardType: TextInputType.emailAddress,
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

  Widget _MotiveTextField() {
    return GestureDetector(
      onTap: () {
        getModalScreen();
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
              color: ColorsPalet.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorsPalet.primaryColor),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 0),
              ]),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("aa"), Icon(Icons.arrow_right)],
            ),
          )),
    );
  }

  Future<dynamic> getModalScreen() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opciones'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                onTap: () {
                  // Lógica para la opción Editar
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar'),
                onTap: () {
                  // Lógica para la opción Eliminar
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Compartir'),
                onTap: () {
                  // Lógica para la opción Compartir
                  Navigator.pop(context);
                },
              ),
            ],
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
              _openModal(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ColorsPalet.backgroundColor,
                  border: Border.all(color: ColorsPalet.primaryColor)),
              height: 40,
              width: 140,
              child: Center(
                  child: Text(
                "Tomar Evidencia",
                style: TextStyle(
                    color: ColorsPalet.primaryColor,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              CameraUtils.getMedia(addMultipleFiles, selectedFiles);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ColorsPalet.backgroundColor,
                  border: Border.all(color: ColorsPalet.primaryColor)),
              height: 40,
              width: 140,
              child: Center(
                  child: Text("Galeria",
                      style: TextStyle(
                          color: ColorsPalet.primaryColor,
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmDataScreen extends StatefulWidget {

  ConfirmDataScreen(
      {super.key});


  @override
  // ignore: library_private_types_in_public_api
  _ConfirmDataScreenState createState() {
    return _ConfirmDataScreenState();
  }
}

class _ConfirmDataScreenState extends State<ConfirmDataScreen> {

  late List<File> filesSelected;
  late Function(int) deleteFile;
  late ConfirmDataModel confirmDataModel;


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(ConfirmDataLabels.title),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.nameLabel),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.cellphone),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.email),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.damageUbi),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.damageMotive),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.reportDate),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(ConfirmDataLabels.evidence),
        ),
      ],
    );
  }
}

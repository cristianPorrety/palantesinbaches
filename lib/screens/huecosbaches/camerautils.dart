import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraUtils {
  static int _maxPhotos = 5;
  static int _maxVideos = 1;

  static Future<void> _capturePhoto(
      Function(File) fileadder, List<File> files) async {
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      if (files.length < _maxPhotos) {
        fileadder(file);
      }
    }
  }

  Future<void> _recordVideo(
      BuildContext context, Function(File) fileadder, List<File> files) async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoRecorderPage(camera: camera),
      ),
    );

    if (result != null) {
      File file = File(result);
      if (files.length < _maxVideos) {
        fileadder(file);
      }
    }
  }
}

class VideoRecorderPage extends StatefulWidget {
  final CameraDescription camera;

  VideoRecorderPage({required this.camera});

  @override
  _VideoRecorderPageState createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String outputPath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grabar Video'),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final timestamp = DateTime.now().millisecondsSinceEpoch;
            outputPath = '${widget.camera.name}_$timestamp.mp4';

            await _controller.startVideoRecording();
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.videocam),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void didUpdateWidget(covariant VideoRecorderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.camera != oldWidget.camera) {
      _controller.dispose();
      _controller = CameraController(
        widget.camera,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    if (brightnessValue == Brightness.dark) {
      _controller.setFlashMode(FlashMode.torch);
    } else {
      _controller.setFlashMode(FlashMode.torch);
    }
  }
}

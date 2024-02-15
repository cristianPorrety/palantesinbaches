import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CameraUtils {
  static int _maxPhotos = 5;
  static int _maxVideos = 1;
  static final picker = ImagePicker();

  static Future<void> capturePhoto(
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

  static Future<void> recordVideo(
      BuildContext context, Function(File) fileadder, List<File> files) async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoRecorderPage(camera: camera, fileadder: fileadder),
      ),
    );

    if (result != null) {
      File file = File(result);
      if (files.length < _maxVideos) {
        fileadder(file);
      }
    }
  }

  static Future<void> getMedia(
      Function(List<File>) fileadder, List<File> files) async {
    List<XFile> selectedFiles = await picker.pickMultipleMedia();
    if (selectedFiles.length < _maxPhotos - files.length) {
      List<File> filesParsed = selectedFiles.map((e) => File(e.path)).toList();
      fileadder(filesParsed);
    }
  }
}

class VideoRecorderPage extends StatefulWidget {
  final CameraDescription camera;
  Function(File) fileadder;

  VideoRecorderPage({required this.camera, required this.fileadder});

  @override
  _VideoRecorderPageState createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String outputPath;
  Icon _iconStop = Icon(Icons.stop);
  Icon _iconRecording = Icon(Icons.stop);
  bool _isRecording = false;

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

            if (_isRecording) {
              final file = await _controller.stopVideoRecording();
              setState(() => _isRecording = false);
              final route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => VideoPage(
                    filePath: file.path, addFileCallback: widget.fileadder),
              );
              Navigator.pushReplacement(context, route);
            } else {
              await _controller.prepareForVideoRecording();
              await _controller.startVideoRecording();
              setState(() => _isRecording = true);
            }
          } catch (e) {
            print(e);
          }
        },
        child: (_isRecording) ? _iconRecording : _iconStop,
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

class VideoPage extends StatefulWidget {
  final String filePath;
  final Function(File) addFileCallback;

  const VideoPage(
      {Key? key, required this.filePath, required this.addFileCallback})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.addFileCallback(File(widget.filePath));
              Navigator.pop(context);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}

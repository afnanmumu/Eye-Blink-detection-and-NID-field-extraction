import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class blinkDetectorView extends StatefulWidget {
  blinkDetectorView({this.onCameraLensDirectionChanged,
    this.initialCameraLensDirection = CameraLensDirection.back,Key? key}) : super(key: key);
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  @override
  State<blinkDetectorView> createState() => _blinkDetectorViewState();
}

class _blinkDetectorViewState extends State<blinkDetectorView> {
  int counter = 0;
  int cameraIndex = -1;
  late List<CameraDescription> cameras = [];
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    if (cameras.isEmpty) cameras = await availableCameras();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == widget.initialCameraLensDirection) {
        cameraIndex = i;
        break;
      }
    }
    if (cameraIndex != -1) {
      startLiveFeed();
    }
    // cameraController =
    //     CameraController(cameras[1], ResolutionPreset.high, enableAudio: false);
    // await cameraController.initialize().then((value) {
    //   if (!mounted) return;
    //   setState(() {});
    // }).catchError((e) {
    //   print('Cannot Mount Camera');
    // });
  }

  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void startLiveFeed(){
    
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Blink detection')),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                child: CameraPreview(cameraController),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Text(
                    counter.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Placeholder();
    }
  }
}

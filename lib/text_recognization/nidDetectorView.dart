import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class nidDetectorView extends StatefulWidget {
  const nidDetectorView({Key? key}) : super(key: key);

  @override
  State<nidDetectorView> createState() => _nidDetectorViewState();
}

class _nidDetectorViewState extends State<nidDetectorView> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  String name = "";
  String dob = "";
  String id = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('NID OCR')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.grey,
                  ),
                if (imageFile != null) Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.file(File(imageFile!.path))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCard("Gallery", () => getImage(ImageSource.gallery)),
                    CustomCard("Camera", () => getImage(ImageSource.camera)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(children: [
                  Text(
                    "Scanned Text:\n" + scannedText,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Extracted Text:\n" + name + '\n' + dob + '\n' + id,
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    scannedText = "";
    name = "";
    dob = "";
    id = "";
    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
        if (line.text.contains("Name:")) {
          name = line.text.replaceAll("Name:", "").trim();
        }
        if (line.text.contains("Date of Birth:")) {
          dob = line.text.replaceAll("Date of Birth:", "").trim();
        }
        if (line.text.contains("ID NO:")) {
          id = line.text.replaceAll("ID NO:", "").trim();
        }
      }
    }
    textRecognizer.close();
    textScanning = false;
    setState(() {});
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;
  const CustomCard(this._label, this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.grey,
          shadowColor: Colors.grey[400],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: _onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.image,
                size: 30,
              ),
              Text(
                _label,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:eye_blink/blink_recog/blinkDetectorView.dart';
import 'package:flutter/material.dart';

import 'eye_blink/blink_detector.dart';
import 'text_recognization/nidDetectorView.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Face and Blink Detector'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCard('NID OCR', nidDetectorView()),
            SizedBox(
              height: 20,
            ),
            CustomCard('Blink Detect', BlinkDetectorView()),
          ],
        ));
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  const CustomCard(this._label, this._viewPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 350,
          height: 80,
          child: OutlinedButton(
              style: ButtonStyle(
                  side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                      style: BorderStyle.solid))),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => _viewPage));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                    ),
                  ),
                  Text(
                    _label,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                    ),
                  ),
                ],
              ))),
    );
  }
}

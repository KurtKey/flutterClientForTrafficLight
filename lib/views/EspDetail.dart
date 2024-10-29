import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/EspController.dart';
import '../models/Esp.dart';
import 'EspMap.dart';

class EspDetailsPage extends StatefulWidget {
  final Esp esp;

  EspDetailsPage({required this.esp});

  @override
  _EspDetailsPageState createState() => _EspDetailsPageState();
}

class _EspDetailsPageState extends State<EspDetailsPage> {
  bool isLightGreen = true; // Initial traffic light state
  String traffic1LedState = 'DEFAULT';
  String traffic2LedState = 'DEFAULT';
  String inverse = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Start a periodic timer to update the LED state
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      displayLedState();
    });
  }
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  void displayLedState() async {
    final newLedState = await fetchLedState();

    if (widget.esp.espNumber == newLedState[2]) {
      setState(() {
        traffic1LedState = newLedState[0];
        traffic2LedState = newLedState[1];
      });
    }
  }
  void _changeLightState() {
    setState(() {
      widget.esp.state ? inverse = 'ON' : inverse = 'OFF';
      inverseTrafficLight(widget.esp.ipAddress, inverse);
    });
  }

  void _openMapPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EspMap(
            espName: widget.esp.espNumber,
            //latitude:23.362646,
            //longitude:-8.557257,
            latitude: double.parse(widget.esp.lat),
            longitude: double.parse(widget.esp.long),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath1;
    String imagePath2;

    if(traffic1LedState == 'RED' && traffic2LedState == 'GREEN'){
      imagePath1 = 'assets/red.png';
      imagePath2 = 'assets/green.png';
    }else if(traffic1LedState == 'RED' && traffic2LedState == 'YELLOW'){
      imagePath1 = 'assets/red.png';
      imagePath2 = 'assets/yellow.png';
    }else if(traffic1LedState == 'GREEN'){
      imagePath1 = 'assets/green.png';
      imagePath2 = 'assets/red.png';
    }else if(traffic1LedState == 'YELLOW'){
      imagePath1 = 'assets/yellow.png';
      imagePath2 = 'assets/red.png';
    }else{
      imagePath1 = 'assets/default.png';
      imagePath2 = 'assets/default.png';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.esp.espNumber),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child:
                  Image.asset(
                    imagePath1,
                    width: 100,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child:
                  Image.asset(
                    imagePath2,
                    width: 100,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("F1"),
                SizedBox(width: 25), // Adjust the width based on your preference
                Text("F2"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeLightState,
              child: Text('Change State'),
            ),
            ElevatedButton(
              onPressed: _openMapPage,
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Change this to the desired color
              ),
              child: const Text('View Location'),
            ),
          ],
        ),
      ),
    );



  }
}

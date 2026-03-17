import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AgitadorDetector extends StatefulWidget {

  const AgitadorDetector({super.key});

  @override
  AgitadorDetectorState createState() => AgitadorDetectorState();
}

class AgitadorDetectorState extends State<AgitadorDetector> {
  Color _corFundo = Colors.white;

  @override
  void initState() {
    super.initState();
    userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      if (event.x > 15 || event.y > 15 || event.z > 15) {
        setState(() {
          _corFundo = Colors.primaries[DateTime.now().second % Colors.primaries.length];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      body: Center(child: Text('Agite o dispositivo!')),
    );
  }
}
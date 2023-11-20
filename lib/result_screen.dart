import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  Uint8List imageBytes;
  ResultScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.memory(
          imageBytes,
          width: 1000, // Adjust as needed
          height: 1000, // Adjust as needed
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DemandsScreen extends StatelessWidget {
  const DemandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demands Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Demands Screen!'),
      ),
    );
  }
}

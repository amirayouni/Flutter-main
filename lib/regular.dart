import 'package:flutter/material.dart';

class RegularScreen extends StatelessWidget {
  const RegularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regular User Screen'),
      ),
      body: Center(
        child: Text('Welcome, regular user!'),
      ),
    );
  }
}

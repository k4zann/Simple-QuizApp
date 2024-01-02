import 'package:flutter/material.dart';

import '../shared/bottom_nav.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
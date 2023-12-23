import 'package:flutter/material.dart';

import '../shared/bottom_nav.dart';
import 'package:flutter_firebase/login/login.dart';
import 'package:flutter_firebase/topics/topics.dart';
import '../services/auth.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong')
            )
          );
        } else if (snapshot.hasData) {
          return const TopicPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
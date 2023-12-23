import 'package:flutter_firebase/home/home.dart';
import 'package:flutter_firebase/profile/profile.dart';
import 'package:flutter_firebase/login/login.dart';
import 'package:flutter_firebase/about/about.dart';
import 'package:flutter_firebase/topics/topics.dart';


var appRoutes = {
  // '/': (context) => HomePage(),
  '/profile': (context) => ProfilePage(),
  '/login': (context) => LoginPage(),
  '/about': (context) => AboutPage(),
  '/topics': (context) => TopicPage(),
};
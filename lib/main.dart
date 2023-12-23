import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:flutter_firebase/services/models.dart';
import 'package:flutter_firebase/themes.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
  ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:1008354798794:android:0849ea892ec8d74ff2d833',
      messagingSenderId: '1008354798794',
      projectId: 'flutter-firebase-37042',
      apiKey: 'AIzaSyAOBrp2va9oyHRAUdFFg4cXaWNYJVRTMAo',
    ),
  ) : Firebase.initializeApp();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}


class _AppState extends State<App> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            ),
            theme: appTheme,
          );
        }

        if(snapshot.connectionState == ConnectionState.done) {
          return StreamProvider(
            create: (_) => FireStoreService().streamReport(),
            initialData: Report(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomePage(),
              routes: appRoutes,
              theme: appTheme,
            ),
          );
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
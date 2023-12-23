import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firestore.dart';

import '../services/models.dart';
import '../shared/bottom_nav.dart';


class TopicPage extends StatelessWidget {
  const TopicPage({super.key});

  @override
  Widget build(context) {
    return FutureBuilder<List<Topic>>(
      future: FireStoreService().getTopics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        } else if (snapshot.hasData) {
          var topics = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Topics'),
            ),
            body: GridView.count(

            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        } else {
          return const Center(
            child: Text('No data found in database.'),
          );
        }
      },
    );
  }
}
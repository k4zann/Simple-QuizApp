import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/models.dart';
import '../shared/bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(user.displayName ?? 'Guest'),
        ),
        body: Center (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 50 ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoURL ?? 'https://www.gravatar.com/avatar/placeholder'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                user.email ?? 'NO email',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              Text(
                'Total Score: ${report.total}',
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                'Quizzes Completed',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Spacer(),
              ElevatedButton(
                child: Text('logout'),
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
              const Spacer()
            ],
          )
        )
      );
    } else {
      return const Center(
        child: Text('No user found.'),
      );
    }
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_firebase/topics/drawer.dart';

import '../services/models.dart';
import '../shared/progress_bar.dart';

class TopicItem extends StatelessWidget {
  final Topic topic;
  final List<Topic> topics;
  TopicItem({super.key, required this.topic, required this.topics});

  @override
  Widget build(context) {
    return Hero(
      tag: topic.img,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TopicScreen(topic: topic, topics: topics))
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  child: Image.asset(
                    'assets/covers/${topic.img}',
                    fit: BoxFit.contain
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: TopicProgress(topic: topic),
              )
            ],
          ),
        ),
      )
    );
  }
}

class TopicScreen extends StatelessWidget{
  final Topic topic;
  final List<Topic> topics;
  const TopicScreen({super.key, required this.topic, required this.topics});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: Colors.transparent,
      ),
      drawer: TopicDrawer(topics: topics),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: topic.img,
              child: SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/covers/${topic.img}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              topic.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO need to understand why does the drawer is not working properly
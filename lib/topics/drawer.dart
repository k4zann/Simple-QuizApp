import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/models.dart';

class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  const TopicDrawer({Key? key, required this.topics}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          Topic topic = topics[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10,),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                )
              ),
              QuizList(topic: topic),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.white70,
          );
        },
      )
    );
  }
}


class QuizList extends StatelessWidget {
  final Topic topic;
  const QuizList({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: topic.quizzes.map((quiz) {
        if (topic.quizzes.isEmpty) {
          return const Center(
            child: Text('No quizzes found.'),
          );
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 4,
          margin: const EdgeInsets.all(4),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/quiz',
                arguments: {
                  'topic': topic,
                  'quiz': quiz,
                }
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  quiz.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  quiz.description,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                // leading: QuizBadge(topic: topic, quizId: quiz.id)
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class QuizBadge extends StatelessWidget {
  final Topic topic;
  final String quizId;

  QuizBadge({Key? key, required this.topic, required this.quizId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    List completed = report.topics[topic.id];
    if (completed != null && completed.contains(quizId)) {
      return const Icon(
        FontAwesomeIcons.checkDouble,
        color: Colors.green,
      );
    } else {
      return const Icon(
        FontAwesomeIcons.solidCircle,
        color: Colors.grey,
      );
    }
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/quiz/quiz_state.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/models.dart';
import '../shared/progress_bar.dart';

class QuizPage extends StatelessWidget {

  const QuizPage({super.key, required this.quizId});
  final String quizId;

  @override
  Widget build(context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder<Quiz>(
        future: FireStoreService().getQuizzes(quizId),
        builder: (context, snapshot){
          var state = Provider.of<QuizState>(context);
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
                child: CircularProgressIndicator()
            );
          } else {
            var quiz = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(value: state.progress,),
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.times),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged: (int index) => state.progress = (index / (quiz.questions.length+1)),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return StartPage(quiz: quiz);
                  } else if (index == quiz.questions.length+1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[index-1]);
                  }
                },
              )
            );
          }
        },
      )
    );
  }
}

class StartPage extends StatelessWidget{
  final Quiz quiz;
  const StartPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            quiz.title,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(),
          Expanded(
            child: Text(
              quiz.description,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  state.nextPage();
                },
                label: const Text('Start'),
                icon: const Icon(Icons.poll),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congratulations!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
            onPressed: () {
              FireStoreService().updateReport(quiz);
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/topics',
                  (route) => false
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            label: const Text('Complete!'),
            icon: const Icon(Icons.check  ),
          )
        ],
      ),
    );
  }
}


class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(context) {
    var state = Provider.of<QuizState>(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              question.text,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: question.options.map((answer) {
              return Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.black26,
                child: InkWell(
                  onTap: () {
                    state.selected = answer;
                    _bottomSheet(
                      context,
                      answer,
                      state
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          state.selected == answer
                              ? FontAwesomeIcons.checkCircle
                              : FontAwesomeIcons.circle,
                          size: 30,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              answer.value,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ),
                        if (state.selected == answer)
                          const Icon(
                            FontAwesomeIcons.checkCircle,
                            color: Colors.green,
                          )
                      ],
                    )
                  )

                ),
              );
            }).toList(),
          )
        )
      ],
    );
  }
  _bottomSheet(BuildContext context, Option answer, QuizState state) {
    bool correct = answer.correct;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                correct ? 'Correct!' : 'Incorrect!',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white54
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (correct) {
                    state.nextPage();
                  }
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  primary: correct ? Colors.green : Colors.red,
                ),
                child: Text(
                  correct ? 'Next Question' : 'Try Again',
                  style: const TextStyle(
                    color: Colors.white54,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}



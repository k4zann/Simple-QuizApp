import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/models.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  const AnimatedProgressBar({Key? key, required this.value, this.height = 12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) => Container(
        padding: const EdgeInsets.all(10),
        width: box.maxWidth,
        child: Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              height: height,
              curve: Curves.easeOutCubic,
              width: _floor(value) * box.maxWidth,
              decoration: BoxDecoration(
                color: _colorGen(value),
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ],
        )
      )
    );
  }

  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rgb = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rgb).withRed(255-rgb);
  }
}

class TopicProgress extends StatelessWidget{
  final Topic topic;
  const TopicProgress({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    return Row(
      children: [
        _progressCount(report, topic),
        Expanded(
          child: AnimatedProgressBar(
            value: _calculateProgress(topic, report),
            height: 8,
          ),
        ),
      ],
    );
  }
}


Widget _progressCount(Report report, Topic topic) {
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Text(
      '${report.topics[topic.id]?.length ?? 0}/${topic.quizzes.length}',
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
      ),
    ),
  );
}

double _calculateProgress(Topic topic, Report report) {
  try {
    List completed = report.topics[topic.id];
    int total = topic.quizzes.length;
    int count = completed != null ? completed.length : 0;
    return count / total;
  } catch (err) {
    return 0.0;
  }
}

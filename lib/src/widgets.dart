import 'dart:async';

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/quiz_screen.dart';

class Header extends StatelessWidget {
  const Header(this.heading, {super.key});
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.yellow[700]!), // use ! to assert that it's not null
      textStyle: TextStyle(color: Colors.grey[900]), // set the text color

    ),
    onPressed: onPressed,
    child: child,
  );
}

class QuizCard extends StatelessWidget
{
  final String quizName;

  const QuizCard( {Key? key, required this.quizName}) : super(key: key);

  //const QuestionCard(this.content, {super.key});
  //final String content;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20.0,),

        child: Material(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.yellow[700]!,
              width: 2,
            ),
          ),
          child: Container(

              child: Column(

                 children: <Widget>[
                Padding(
                padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
                  child: Material(
                   elevation: 10.0,
                   borderRadius: BorderRadius.circular(110.0),
                    child: Container(
                    // changing from 200 to 150 as to look better
                        height: 160.0,
                        width: 160.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage("quiz.jpg"),
                        ),
                  ),
                  ),
                    ),

  ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(quizName,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ),
                ),
              ],

    ),
  ),
  ),
   // ),
  );

}

class ProgressBarWithTimer extends StatefulWidget {
  final int durationSeconds;
  final Function onTimerComplete;

  const ProgressBarWithTimer({
    Key? key,
    required this.durationSeconds,
    required this.onTimerComplete,
  }) : super(key: key);

  @override
  _ProgressBarWithTimerState createState() => _ProgressBarWithTimerState();
}

class _ProgressBarWithTimerState extends State<ProgressBarWithTimer> {
  late Timer _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.durationSeconds;
    startTimer();
  }

  void startTimer() {
    const tick = const Duration(seconds: 1);
    _timer = Timer.periodic(tick, (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          widget.onTimerComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getFormattedTime() {
    final minutes = (_counter ~/ 60).toString().padLeft(2, '0');
    final seconds = (_counter % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds Seconds left ';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _counter / widget.durationSeconds;
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            getFormattedTime(),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow.shade700),
          ),
        ],
      ),
    );
  }
}




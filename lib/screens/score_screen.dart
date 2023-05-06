import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  ScoreScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    // Calculate user's score and display it
    final appState = Provider.of<ApplicationState>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Image(
            height:400,
            width: 400,
            image: AssetImage("quizResultBadge.png"),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                SizedBox(height: 10.0), // adds 10 pixels of vertical spacing

                Text(
                  "Congratulations!",
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0), // adds 10 pixels of vertical spacing

                Text(
                  "You have completed the quiz , Each correct answer earned you 5 points..",
                ),
                SizedBox(height: 10.0), // adds 10 pixels of vertical spacing

                Text(
                  "Your score is  ${appState.score}" ,
                  style: TextStyle(
                    color: Colors.yellow[700],

                  ),
                ),
              ],
            ),
          ),




        ],
    ),);
    }
  }

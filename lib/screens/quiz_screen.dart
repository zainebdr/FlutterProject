import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import  'package:firebase_core/firebase_core.dart';
import 'package:gtk_flutter/screens/score_screen.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../src/widgets.dart';

class QuizScreen extends StatefulWidget {
  final String quizName;
  const QuizScreen(  {superkey, String? quizId,  required this.quizName});


  @override
  State<QuizScreen> createState() => _MyQuizScreenState();

}
  class _MyQuizScreenState extends State<QuizScreen> {
    int? selectedValue;
    int _currentIndex = 0;
    List<Question> _questions=[];
     int _score =0;
    void _nextQuestion() {

      setState(() {
        _currentIndex++;

        print(_currentIndex);
        if (_currentIndex > _questions.length -1) {
          // reached the last question, navigate to score page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ScoreScreen(score:_score)),

          );
        }
      }

      );
    }
    @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text(widget.quizName+" Quiz"),
          // Fluttter show the back button automatically
          backgroundColor: Colors.transparent,
          elevation: 0,
         actions: [
               TextButton(
                 onPressed:() {     onNextQuestion: _nextQuestion();
                   //_nextQuestion();
                   //QuestionNavigator(context: context, questions: _questions, currentIndex: _currentIndex).nextQuestion();
                 ;

    }  ,

                 child: Text("Next", style: TextStyle(
                   color: Colors.yellow.shade700,
                 ),),
               ),

    ],
        ),
      body : Stack(
        children:[
        SafeArea(
         child: Column (
           crossAxisAlignment: CrossAxisAlignment.start,
           children:[
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16/2),
             ),
              StreamBuilder(
                stream:FirebaseFirestore.instance.collection('Quiz').doc(widget.quizName).collection('questions').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Text('Err: ${snapshot.error.toString()}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if (!snapshot.hasData) {
                    return Text('Something went wrong');
                  }

                   _questions = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return Question(
                      question: data['question'],
                      answer: data['answer'],
                      responses: data['responses'],
                        onNextQuestion: _nextQuestion,
                    );
                  }).toList();

                  return
                      _questions[_currentIndex];

                },
              ),

            ],
         ),
    ),
    ],
      ),

    );



  }


  }

class Question extends StatefulWidget {
  final String question;
  final int answer;
  final List<dynamic> responses;
  final VoidCallback onNextQuestion;



  const Question({
    required this.question,
    required this.answer,
    required this.responses,
    required this.onNextQuestion,

  });

  @override
  State<Question> createState() => _QuestionState();
}
class _QuestionState extends State<Question> {
  int? _selectedValue = -1;
  late  int _score = 0;



  @override
  Widget build(BuildContext context) {
    final appState=Provider.of<ApplicationState>(context);
    var i=0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          ProgressBarWithTimer(
            durationSeconds: 10,
            onTimerComplete: ()  {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Time\'s up!'),
                        content: Text('Let''s pass to the next question .'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onNextQuestion();

                            },
                          ),
                        ]
                    );
                  }

              );            },
          ),
          SizedBox(height: 40), // add some space between the widgets
          Text(
            'Question '+(i+1).toString() ,

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.all(10),


            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.responses.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isCorrect = index + 1 == widget.answer;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: _selectedValue == index ? Colors.blue.shade50 : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text(
                          widget.responses[index],
                          style: TextStyle(
                            fontSize: 16,

                          ),
                        ),
                        value: index,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                            if (isCorrect) {
                              appState.inrementScroe();
                              //score++;
                              print ("scoooore : "+appState.score.toString());
                            }

                          });
                        },

                        activeColor: isCorrect ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),

          )
        ],
      ),
    );
  }
}











import 'dart:convert';

import 'package:firebase_ui_auth/src/actions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import  'package:firebase_core/firebase_core.dart';
import 'package:gtk_flutter/screens/player_screen.dart';
import 'package:gtk_flutter/screens/quiz_screen.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../src/widgets.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({superkey, required List<SignedOutAction> actions});
  @override
  State<QuizListScreen> createState() => _QuizListState();
}
class _QuizListState extends State<QuizListScreen> {
  final Stream<QuerySnapshot> quiz = FirebaseFirestore.instance.collection('Quiz').snapshots();

  //  final appState = ApplicationState();


  @override
  Widget build(BuildContext context) {
    final appState=Provider.of<ApplicationState>(context);
    appState.resetscroe();
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body : StreamBuilder(
        stream:quiz,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
         // Extract quiz names from the first document in the snapshot
          // var docs = snapshot.data!.docs[0]['quizNames'];

          List<String> quizIds = [];
          for (DocumentSnapshot document in snapshot.data!.docs) {
            quizIds.add(document.id);
          }

          return ListView.builder( //is used when you have a large number of items to display, and you need to build the list dynamically as the user scrolls through it
            itemCount: quizIds.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // additional action to perform when the QuizCard is tapped
              // Navigator.of(context).pushNamed('QuizScreen/${quizIds[index]}');

                  Navigator.of(context).push(MaterialPageRoute(
                    //pushReplacement() method replaces the current route at the top of the Navigator's stack with a new route.
                    // The user cannot return to the previous screen by pressing the back button.
                   builder: (context) =>PlayerScreen(quizName:'${quizIds[index]}' ),
                  ), //QuizScreen(quizName:'${quizIds[index]}')
                  ) ;
                  //)
                 // );
                   },
                    child: QuizCard(quizName: quizIds[index]),
              );


            }
          );

        },

      ),
    );
  }
}

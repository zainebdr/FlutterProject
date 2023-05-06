// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';          // new

import '../app_state.dart';                          // new
import '../src/authentication.dart';                 // new
import '../src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Welcome to our Quiz App'),
        ),

      ),

      body: Row( //ListView is a widget used to display a scrolling list of items
        children: <Widget>[

      LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
            return Container(

                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                    "photo.png",
                    fit: BoxFit.cover,
                    ),
                    ),
                    );
                },
                ),

        const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: StyledButton(
                    onPressed: () {
                  context.push('/QuizList');
                },
                  child: const Text('Quiz List',  style: TextStyle(color: Colors.black),
                  )),
            ),

          // widget consumer est le moyen habituel d'utiliser le package provider
          //accéder aux données stockées dans une instance de "ApplicationState"
          Consumer<ApplicationState>( // intégrez l'état de l'application au widget AuthFunc :
            builder: (context, appState, _) => AuthFunc( // instanciez le widget AuthFunc et l'encapsulez dans un widget Consumer
                //AuthFunc prend 2 parametre  "loggedIn" et "signOut"
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                  }),
            ),




        ],
      ),
    );
  }
}

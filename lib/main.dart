// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';               // new
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/screens/quiz_screen.dart';
import 'package:provider/provider.dart';                 // new
import 'firebase_options.dart';
import 'screens/quiz_list_screen.dart';
import 'app_state.dart';                                 // new
import 'screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/quiz_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); //for ensuring that the binding is properly initialized

  try {
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);//using await here to ensure that Firebase is fully initialized before running the app.

  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),//create an instance of the AppState
    builder: ((context, child) => const App()), // and pass it down to the MaterialApp widget
  ));
  // ...to here.
}

// Add GoRouter configuration outside the App class
final _router = GoRouter( //provides a convenient URL-based API to navigate between different screens.
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) { //widget qui sera affiché sur cet itinéraire :SignInScreen
            return SignInScreen(
              actions: [ //liste d'actions qui seront exécutées lors de différents événements
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString()); // utilisée pour naviguer vers l'itinéraire spécifié dans l'URL
                })),
                AuthStateChangeAction(((context, state) {
                  if (state is SignedIn || state is UserCreated) {
                    var user = (state is SignedIn)
                        ? state.user // si la cond est vrai
                        : (state as UserCreated).credential.user; // la valeur est fausse
                    if (user == null) {
                      return;
                    }
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);//une liste de sous-chaînes qui ont été séparées par le symbole spécifié
                    }
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      const snackBar = SnackBar( //message SnackBar affiche un message temporaire au-dessus de l'écran.
                          content: Text('Please check your email to verify your email address'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar); //Le ScaffoldMessenger permet  d'afficher le SnackBar sur le Scaffold parent le plus proche.
                    }
                    context.pushReplacement('/'); //redirige vers la page d'accueil de l'application.
                  }
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.queryParams;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200, //contrôle la hauteur maximale de la section de l'en-tête de l'application dans un widget SliverAppBar.
                );
              },
            ),
          ],
        ),

      ],
    ),
    GoRoute(path: '/QuizList',
            builder: (context, state) {
            return QuizListScreen(
            actions: [
            SignedOutAction((context) {
            context.pushReplacement('/');

            }
            ),
            ],
            );
            },
              routes: [
                  GoRoute(
                  path: 'QuizScreen/:quizName', // path parameter for the quizName
                  builder: (context, state) {
                  final quizName = state.params['quizName'];
                if (quizName != null) {
                  return QuizScreen(quizName: quizName);
                  }
                  return QuizScreen(quizName: 'Flutter');

                  },
                  ),
              ],



),


],);


// end of GoRouter configuration

// Change MaterialApp to MaterialApp.router and add the routerConfig
class App extends StatelessWidget {
  const App({super.key});


  @override
  Widget build(BuildContext context) {

    return  MaterialApp.router(
      title: 'Quiz Application',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.dark(),

      theme: ThemeData(
        primaryColor: Colors.yellow[700],
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.yellow.shade700,
            ),
        //primarySwatch: Colors.yellow.shade700, //la couleur principale de l'application.
        textTheme: GoogleFonts.robotoTextTheme( //police de caractères "Roboto" de Google.
          Theme.of(context).textTheme, //appliquer facilement une typographie cohérente à travers l'application.
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity, //permet à l'application d'adapter la densité visuelle en fonction de la plate-forme sur laquelle elle s'exécute
        useMaterial3: true,//framework Material3 de Google pour la conception d'interfaces utilisateur maj du framework Material Design de Google
      ),
       routerConfig: _router,
    );
  }
}

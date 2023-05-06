import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gtk_flutter/screens/quiz_screen.dart';

class PlayerScreen extends StatelessWidget {
   final String quizName;

  const PlayerScreen(  {superkey, String? quizId, required this.quizName});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2), //2/6
                  Text(
                    "Let's Play "+quizName+" Quiz,",
                    style: TextStyle(
                      color: Colors.yellow.shade700,
                      fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                      fontFamily: Theme.of(context).textTheme.headlineMedium!.fontFamily,
                      fontWeight: Theme.of(context).textTheme.headlineMedium!.fontWeight,
                    ),),
                  Text("Enter your informations below"),

                  Spacer(), // 1/6
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                     // fillColor: Color(),
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.yellow[700]!, width: 2.0),
                      ),
                      fillColor: Colors.white,
                    ),
                    ),

                  Spacer(), // 1/6
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(quizName: quizName),
                        ),
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10 * 0.75), // 15
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Lets Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.yellow.shade700),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
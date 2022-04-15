//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/intro_screen.dart';
import 'package:untitled/screens/price_screen.dart';

void main (){
  runApp(const ScubaDiving());
}

class ScubaDiving extends StatelessWidget {
  const ScubaDiving({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
        routes: {
        '/': (context) => const IntroScreen(),
          '/price': (context) => const PriceScreen(),
        },
        initialRoute: '/',
        );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled/screens/intro_screen.dart';
import 'package:untitled/screens/price_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main (){
  runApp(const ScubaDiving());
}

class ScubaDiving extends StatelessWidget {
  const ScubaDiving({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(primarySwatch: Colors.blueGrey),
        routes: {
          '/': (context) => const IntroScreen(),
          '/price': (context) => const PriceScreen(),
        },
        initialRoute: '/',
        );
  }
}

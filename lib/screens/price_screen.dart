//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:untitled/shared/menu_bottom.dart';
import '../shared/menu_drawer.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final TextEditingController txtNumberOfLessons = TextEditingController();
  final double fontSize = 18;
  String result = '';
  bool isZloty = true;
  bool isDollar = false;
  int? numberOfLessons;
  late List<bool> isSelected;
  String message = '';

  @override
  void initState() {
    isSelected = [isZloty, isDollar];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    message = 'Number of lessons you want to calculate in '
    + ((isZloty)? 'zlotys': 'dollars');
    return Scaffold(
      appBar: AppBar(title: Text('Price')),
      bottomNavigationBar: MenuBottom(),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Column(children: [
          ToggleButtons(
              children:[
                Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Zloty', style:  TextStyle(fontSize: fontSize)),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Dollar', style:  TextStyle(fontSize: fontSize)),
                ),
            ],
            isSelected: isSelected, onPressed: toggleMeasure),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(controller: txtNumberOfLessons, keyboardType: TextInputType.number,
                onChanged: findPrice2,
              decoration: InputDecoration(
                hintText: message
              ),
              ),
            ),
          ElevatedButton(
              child: Text('Calculate price',
              style: TextStyle(
                fontSize: fontSize
              )),
            onPressed: findPrice,
          ),
          Text(result,
          style: TextStyle(
            fontSize: fontSize
          ))
        ]),
      ),
    );
  }

  void toggleMeasure(value) {
            if (value == 0){
              isZloty = true;
              isDollar = false;
            } else{
              isZloty = false;
              isDollar = true;
            }
            setState(() {
              isSelected = [isZloty, isDollar];
            });
  }

  void findPrice() {
    double price = 0;
    int numberOfLessons = int.tryParse(txtNumberOfLessons.text) ?? 0;
    if(isZloty){
      price = numberOfLessons * 50;
    } else {
      price = numberOfLessons * 50 * 0.23;
    }
    setState(() {
      result = 'The cost of your order is ' + price.toStringAsFixed(2);
    });
  }

  void findPrice2(String number) {
    double price = 0;
    int numberOfLessons = int.tryParse(number) ?? 0;
    if(isZloty){
      price = numberOfLessons * 50;
    } else {
      price = numberOfLessons * 50 * 0.23;
    }
    setState(() {
      result = 'The cost of your order is ' + price.toStringAsFixed(2);
    });
  }
}

import 'package:fashion/models/mainmodel.dart';
import 'package:fashion/screens/bottomnavbar/profile/order.dart';
import 'package:fashion/screens/bottomnavbar/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: MainModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreens(),
        routes: {
          'order' : (context) => Order(), 
        },
      ),
    );
  }
}
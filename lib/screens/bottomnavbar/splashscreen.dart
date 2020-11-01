import 'package:fashion/screens/bottomnavbar/bottomnavbar.dart';
import 'package:fashion/screens/bottomnavbar/sign.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';



class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {

String email;

check() async {
  SharedPreferences _data = await SharedPreferences.getInstance();
  setState(() {
    email = _data.getString('uid');
  });
}


@override
void initState() {
  check();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 7,
      navigateAfterSeconds: email == null ? Sign() : BottomNavBar(),
      title: Text('Welcome In SplashScreen'),
      image: Image.asset('assets/chair.jpg'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.red
    );
  }
}
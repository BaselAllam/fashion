import 'dart:io';

import 'package:fashion/screens/bottomnavbar/profile/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 2.0, 5.0, 0.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    margin: EdgeInsets.only(left: 5.0, right: 15.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/pp'),
                        fit: BoxFit.fill
                      ),
                      shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: Colors.white,
                      iconSize: 20.0,
                      onPressed: () {},
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adam',
                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        'adam@app.com',
                        style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            item('Wishlist', Icons.favorite, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {return Wishlist();}));
            }),
            item('Order History', Icons.replay, () {
              Navigator.pushNamed(context, 'order');
            }),
            item('Setting', Icons.settings, () {}),
            item('Contact', Icons.mail, () {}),
            item('About Us', Icons.info_outline, () {}),
            item('LogOut', Icons.exit_to_app, () async {
              SharedPreferences _data = await SharedPreferences.getInstance();
              _data.clear();
              //exit(0);
            }),
          ],
        )
      ),
    );
  }
  item(String title, IconData leading, Function onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
      ),
      leading: Icon(
        leading,
        color: Colors.black,
        size: 20.0
      ),
      trailing: title != 'LogOut' ? Icon(
        Icons.navigate_next,
        color: Colors.grey,
        size: 20.0
      ): null,
      onTap: onTap
    );
  }
}
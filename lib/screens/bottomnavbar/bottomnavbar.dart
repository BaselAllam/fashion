import 'package:fashion/models/item/itemController.dart';
import 'package:fashion/models/mainmodel.dart';
import 'package:fashion/screens/bottomnavbar/homepage.dart';
import 'package:fashion/screens/bottomnavbar/profile.dart';
import 'package:fashion/screens/bottomnavbar/sell.dart';
import 'package:fashion/screens/bottomnavbar/shoppingcart.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Sell'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: current,
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel item){
          if(current == 0){
            return HomePage(item);
          }else if(current == 1){
            return ShoppingCart();
          }else if(current == 2){
            return Sell();
          }else{
            return Profile();
          }
        }
      ),
    );
  }
}
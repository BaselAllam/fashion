import 'dart:io';

import 'package:fashion/models/mainmodel.dart';
import 'package:fashion/screens/bottomnavbar/bottomnavbar.dart';
import 'package:fashion/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> with TickerProviderStateMixin {

TabController tabController;


@override
void initState() {
  tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Welcome!',
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
        iconTheme: IconThemeData(color: Colors.black, size: 20.0),
        bottom: PreferredSize(
          preferredSize: Size(0.0, 30.0),
          child: TabBar(
            tabs: [
              Text('Signin'), Text('Register')
            ],
            controller: tabController,
            indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 1.0)),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 15.0),
            unselectedLabelStyle: TextStyle(fontSize: 10.0),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            SignIn(),
            Register()
          ]
        ),
      ),
    );
  }
}





class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController emailResetController = TextEditingController();


final GlobalKey<FormFieldState<String>> emailKey = GlobalKey<FormFieldState<String>>();
final GlobalKey<FormFieldState<String>> passwordKey = GlobalKey<FormFieldState<String>>();

final _formKey = GlobalKey<FormState>();

bool secure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            field('email', Icons.email, TextInputType.emailAddress, emailController, emailKey),
            field('password', Icons.lock, TextInputType.text, passwordController, passwordKey),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                child: Text(
                  'Forgot Password?!',
                  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(
                          'Attention',
                          style: TextStyle(color: Colors.red, fontSize: 15.0, fontWeight: FontWeight.normal),
                        ),
                        content: field('email', Icons.email, TextInputType.emailAddress, emailResetController, null),
                        actions: [
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            color: Colors.black,
                            child: Text(
                              'send link',
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {},
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            color: Colors.black,
                            child: Text(
                              'cancel',
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
            ),
            Column(
              children: [
                ScopedModelDescendant<MainModel>(
                  builder: (context, child, MainModel model){
                    return FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.black,
                      child: model.isUSerLoading == true ? Center(child: Loading()) : Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                            bool _valid = await model.signIn(emailController.text, passwordController.text);
                            if(_valid == false){
                              return Scaffold.of(context).showSnackBar(snack('invalid data try again!'));
                            }else{
                              return Navigator.push(context, MaterialPageRoute(builder: (_) {return BottomNavBar();}));
                            }
                          }else{
                          return Scaffold.of(context).showSnackBar(snack('some fields required!'));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  snack(String content) {
    return SnackBar(
      content: Text(
        content,
        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 4),
    );
  }
  field(String label, IconData icon, TextInputType type, TextEditingController controller, Key key) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        key: key,
        validator: (value) {
          if(value.isEmpty){
            return 'this field is required';
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.red, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20.0),
          suffixIcon: label == 'password' ? IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.grey,
            onPressed : () {
              setState(() {
                secure = !secure;
              });
            }
          ) : null
        ),
        textInputAction: TextInputAction.done,
        keyboardType: type,
        controller: controller,
        obscureText: label == 'password' ? secure : false,
      ),
    );
  }
}





class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

DateTime pickedDate = DateTime.now();

bool checked = false;

File pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: pickedImage == null ? AssetImage('assets/office.jpg') : FileImage(pickedImage),
                fit: BoxFit.fill
              ),
            ),
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              color: Colors.black, 
              iconSize: 20.0,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (BuildContext context){
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Camera'
                            ),
                            trailing: Icon(Icons.camera, color: Colors.black, size: 20.0),
                            onTap: () {
                              pickImage(ImageSource.camera);
                            }
                          ),
                          ListTile(
                            title: Text(
                              'Gallery'
                            ),
                            trailing: Icon(Icons.photo_album, color: Colors.black, size: 20.0),
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            }
                          ),
                        ],
                      )
                    );
                  }
                );
              }
            ),
          ),
          ListTile(
            title: Text(
              'Birth Date',
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              pickedDate.toString().substring(0, 10),
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              var _picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
              );
              setState(() {
                if(_picked == null){
                  pickedDate = DateTime.now();
                }else{
                  pickedDate = _picked;
                }
              });
            },
          ),
          ListTile(
            title: Text(
              'Terms & Conditions',
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Read our Terms & Conditions',
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            trailing: Checkbox(
              activeColor: Colors.white,
              checkColor: Colors.black,
              hoverColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  if(checked == false){
                    return null;
                  }else{
                    checked = value;
                  }
                });
              },
              value: checked
            ),
            onTap: () {
              setState((){
                checked = true;
              });
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (BuildContext context){
                  return ListTile(
                    title: Text(
                      'Terms & Conditions',
                      style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Terms & Conditions our Terms & Conditions our  Terms & Conditions our  Terms & Conditions our  Terms & Conditions our  Terms & Conditions our ',
                      style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              );
            }
          ),
        ],
      ),
    );
  }
  pickImage(ImageSource source) async {
    var _pickedImage = await ImagePicker.pickImage(source: source);
    setState(() {
      pickedImage = _pickedImage;
    });
  }
}
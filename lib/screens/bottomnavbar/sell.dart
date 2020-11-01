import 'dart:io';

import 'package:fashion/models/item/itemController.dart';
import 'package:fashion/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';




class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {

File pickedImage;

final TextEditingController nameController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();


final GlobalKey<FormFieldState<String>> nameKey = GlobalKey<FormFieldState<String>>();
final GlobalKey<FormFieldState<String>> priceKey = GlobalKey<FormFieldState<String>>();
final GlobalKey<FormFieldState<String>> descriptionKey = GlobalKey<FormFieldState<String>>();

final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Sell',
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
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
            field('Item Name', nameController, nameKey),
            field('Item Price', priceController, priceKey),
            field('Item Description', descriptionController, descriptionKey),
            Column(
              children: [
                ScopedModelDescendant<ItemController>(
                  builder: (context, child, ItemController item){
                    return FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.black,
                      child: item.isProductLoading == true ? Center(child: Loading()) : Text(
                        'Sell Item',
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          bool _valid = await item.addItem(nameController.text, double.parse(priceController.text), descriptionController.text);
                          if(_valid == true){
                            return Scaffold.of(context).showSnackBar(snack('item added sucess!'));
                          }else{
                            return Scaffold.of(context).showSnackBar(snack('some thing went wrong try again!'));
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
  field(String label, TextEditingController controller, Key key) {
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
        ),
        textInputAction: TextInputAction.done,
        controller: controller,
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
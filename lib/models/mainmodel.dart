import 'package:fashion/models/item/itemController.dart';
import 'package:fashion/models/user/usercontroller.dart';
import 'package:scoped_model/scoped_model.dart';




class MainModel extends Model with UserController, ItemController{}
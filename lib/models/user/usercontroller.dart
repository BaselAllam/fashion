import 'package:fashion/models/user/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';




mixin UserController on Model{


  bool _isUserLoading = false;
  bool get isUSerLoading => _isUserLoading;

  
  UserModel user;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> signUp(String email, String password) async {

    _isUserLoading = true;
    notifyListeners();

    AuthResult _result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);


    if(_result.user.uid == null){
      _isUserLoading = false;
      notifyListeners();
      return false;
    }else{
      SharedPreferences _data = await SharedPreferences.getInstance();
      _data.setString('uid', _result.user.uid);
      _isUserLoading = false;
      notifyListeners();
      return true;
    }

  }


  Future<bool>  signIn(String email, String password) async {

   _isUserLoading = true;
    notifyListeners();

    AuthResult _result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password); 

    if(_result.user.uid == null){
      _isUserLoading = false;
      notifyListeners();
      return false;
    }else{
      SharedPreferences _data = await SharedPreferences.getInstance();
      _data.setString('uid', _result.user.uid);
      _isUserLoading = false;
      notifyListeners();
      return true;
    }    
  }


  signOut() async {

    _isUserLoading = true;
    notifyListeners();

    firebaseAuth.signOut();

    _isUserLoading = true;
    notifyListeners();
  }
  
}
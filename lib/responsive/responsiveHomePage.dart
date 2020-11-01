import 'package:flutter/widgets.dart';




responsiveScrollContainer(MediaQueryData data) {

  double _deviceHeight = data.size.height;


  if(_deviceHeight <= 720){
    return data.size.height/2.3;
  }else if(_deviceHeight <= 745){
    return data.size.height/3;
  }else{
    return data.size.height/3.5;
  }
}



responsiveGridViewItem(MediaQueryData data) {

  double _deviceHeight = data.size.height;


  if(_deviceHeight <= 720){
    return 0.6;
  }else if(_deviceHeight <= 745){
    return 0.8;
  }else{
    return data.size.height/3.5;
  }
}
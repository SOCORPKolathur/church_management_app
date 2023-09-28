import 'package:flutter/material.dart';

class Constants{
  Color primaryAppColor = const Color(0xffE7B41F);

  double getFontSize(BuildContext context, String textType){
    double fontSize = 13.0;
    Size size = MediaQuery.of(context).size;
    switch(textType){
      case "XL":
        fontSize = size.height * 0.04;
        break;
      case "ML":
        fontSize = size.height * 0.033;
        break;
      case "L":
        fontSize = size.height * 0.03;
        break;
      case "M":
        fontSize = size.height * 0.024;
        break;
      case "SM":
        fontSize = size.height * 0.022;
        break;
      case "S":
        fontSize = size.height * 0.017;
        break;
      case "K":
        fontSize = size.height * 0.0156;
        break;
    }
    return fontSize;
  }

}
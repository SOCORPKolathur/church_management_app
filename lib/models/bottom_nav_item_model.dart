import 'package:flutter/material.dart';

class BottomNavItem {
  BottomNavItem({this.name, this.icon, this.header, this.page});

  String? name;
  IconData? icon;
  Widget? header;
  Widget? page;
}
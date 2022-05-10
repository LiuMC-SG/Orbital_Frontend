import 'package:flutter/material.dart';

class SideMenuItem {
  static int id = 0;

  late int thisId;
  String title;
  IconData icon;
  SideMenuItem(this.title, this.icon) {
    thisId = SideMenuItem.id;
    SideMenuItem.id++;
  }

  generateListTile(Function(int) selectedCheck, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedCheck(thisId),
      onTap: onTap,
    );
  }
}

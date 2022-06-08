import 'package:flutter/material.dart';

// Side menu item model
class SideMenuItem {
  static int id = 0;

  late int thisId;
  String title;
  IconData icon;
  SideMenuItem(this.title, this.icon) {
    thisId = SideMenuItem.id;
    SideMenuItem.id++;
  }

  // Generate side menu item from data
  generateListTile(Function(int) selectedCheck, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedCheck(thisId),
      onTap: onTap,
    );
  }
}

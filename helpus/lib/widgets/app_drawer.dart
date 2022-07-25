import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpus/models/drawer_item.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/profile/profile_photo.dart';

class AppDrawer {
  // All side menu options
  static final List<SideMenuItem> sideMenuItems = [
    SideMenuItem(
      'Profile',
      Icons.account_circle_rounded,
    ),
    SideMenuItem(
      'Module Graph',
      Icons.backup_table,
    ),
    SideMenuItem(
      'Module Tracking',
      Icons.book_rounded,
    ),
    SideMenuItem(
      'To Do',
      Icons.assignment_rounded,
    ),
  ];

  // Provide the common menu drawer to be used between all screen
  static Drawer getDrawer(BuildContext context, Profile profile, int index) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: ProfilePhoto(
                profile: profile,
              ),
            ),
          ),
          ...sideMenuOptions(context, index),
        ],
      ),
    );
  }

  // Generate all side menus
  static List<Widget> sideMenuOptions(BuildContext context, int index) {
    List<ListTile> sideMenuOptions = <ListTile>[];

    for (int i = 0; i < sideMenuItems.length; i++) {
      SideMenuItem sideMenuItem = sideMenuItems[i];
      sideMenuOptions.add(ListTile(
        leading: Icon(sideMenuItem.icon),
        title: Text(sideMenuItem.title),
        selected: i == index,
        onTap: () => _onItemSelect(context, i),
      ));
    }

    sideMenuOptions.add(ListTile(
      leading: const Icon(
        Icons.exit_to_app_rounded,
      ),
      title: const Text(
        'Logout',
      ),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Future.delayed(Duration.zero, () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesText.signIn,
            (route) => false,
          );
        });
      },
    ));

    return sideMenuOptions;
  }

  static void _onItemSelect(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(
          context,
          RoutesText.profile,
        );
        break;
      case 1:
        Navigator.pushNamed(
          context,
          RoutesText.moduleGraph,
        );
        break;
      case 2:
        Navigator.pushNamed(
          context,
          RoutesText.moduleTracking,
        );
        break;
      case 3:
        Navigator.pushNamed(
          context,
          RoutesText.todo,
        );
        break;
      default:
        break;
    }
  }
}

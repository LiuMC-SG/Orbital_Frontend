import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/screens/module_generation_screen.dart';
import 'package:helpus/screens/module_graph_screen.dart';
import 'package:helpus/screens/module_tracking_screen.dart';
import 'package:helpus/screens/profile_screen.dart';
import 'package:helpus/screens/settings_screen.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/models/drawer_item.dart';

class HomeScreen extends StatefulWidget {
  final List<SideMenuItem> sideMenuItems = [
    SideMenuItem(
      "Profile",
      Icons.account_circle_rounded,
    ),
    SideMenuItem(
      "Settings",
      Icons.settings_rounded,
    ),
    SideMenuItem(
      "Module Graph",
      Icons.backup_table,
    ),
    SideMenuItem(
      "Module Tracking",
      Icons.book_rounded,
    ),
    SideMenuItem(
      "Module Generation",
      Icons.view_carousel_rounded,
    ),
  ];

  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  void _onItemSelect(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop();
  }

  Widget _getDrawerItemWidget(int index) {
    switch (index) {
      case 0:
        return const ProfileScreen();
      case 1:
        return const SettingsScreen();
      case 2:
        return const ModuleGraphScreen();
      case 3:
        return const ModuleTrackingScreen();
      case 4:
        return const ModuleGenerationScreen();
      default:
        return const Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> sideMenuOptions = <ListTile>[];
    for (int i = 0; i < widget.sideMenuItems.length; i++) {
      SideMenuItem sideMenuItem = widget.sideMenuItems[i];
      sideMenuOptions.add(ListTile(
        leading: Icon(sideMenuItem.icon),
        title: Text(sideMenuItem.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onItemSelect(i),
      ));
    }

    // Logout Option
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

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL ?? ""),
                ),
              ),
            ),
            ...sideMenuOptions,
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "HelpUS",
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Menu",
            );
          },
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

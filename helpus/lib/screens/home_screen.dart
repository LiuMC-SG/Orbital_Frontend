import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/screens/module_generation_screen.dart';
import 'package:helpus/screens/module_graph_screen.dart';
import 'package:helpus/screens/module_tracking_screen.dart';
import 'package:helpus/screens/profile/profile_screen.dart';
import 'package:helpus/screens/settings_screen.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/models/drawer_item.dart';
import 'package:helpus/widgets/profile/profile_photo.dart';
import 'package:helpus/models/profile_data.dart';

class HomeScreen extends StatefulWidget {
  final List<SideMenuItem> sideMenuItems = [
    SideMenuItem(
      'Profile',
      Icons.account_circle_rounded,
    ),
    SideMenuItem(
      'Settings',
      Icons.settings_rounded,
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
      'Module Generation',
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

  Widget _getDrawerItemWidget(int index, Profile profile) {
    switch (index) {
      case 0:
        return ProfileScreen(
          profile: profile,
        );
      case 1:
        return const SettingsScreen();
      case 2:
        return ModuleGraphScreen(
          profile: profile,
        );
      case 3:
        return const ModuleTrackingScreen();
      case 4:
        return const ModuleGenerationScreen();
      default:
        return const Text('Error');
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

    return FutureBuilder(
      future: checkProfile(),
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        return snapshot.hasData
            ? Scaffold(
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: ProfilePhoto(
                            profile: snapshot.data ?? Profile.blankProfile,
                          ),
                        ),
                      ),
                      ...sideMenuOptions,
                    ],
                  ),
                ),
                appBar: AppBar(
                  title: const Text(
                    'HelpUS',
                  ),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: 'Menu',
                      );
                    },
                  ),
                ),
                body: _getDrawerItemWidget(
                  _selectedDrawerIndex,
                  snapshot.data ?? Profile.blankProfile,
                ),
              )
            : const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 40,
                ),
              );
      },
    );
  }

  Future<Profile> checkProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      documentReference.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'graphModel': GraphModel.blankGraphModel.toJson(),
      });
    }
    Profile profile = await Profile.generate(user.uid);
    return profile;
  }
}

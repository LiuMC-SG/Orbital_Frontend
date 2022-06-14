import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/todo_data.dart';
import 'package:helpus/screens/module_graph/module_graph_screen.dart';
import 'package:helpus/screens/tracking/module_tracking_screen.dart';
import 'package:helpus/screens/profile/profile_screen.dart';
import 'package:helpus/screens/todo/todo_screen.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/models/drawer_item.dart';
import 'package:helpus/widgets/profile/profile_photo.dart';
import 'package:helpus/models/profile_data.dart';

// Home screen [After login]
class HomeScreen extends StatefulWidget {
  // Side bar drawer items
  final List<SideMenuItem> sideMenuItems = [
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
  HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;
  Profile profile = Profile.blankProfile();

  void _onItemSelect(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _getDrawerItemWidget(int index, Profile profile) {
    switch (index) {
      case 0:
        return const ProfileScreen();
      case 1:
        return const ModuleGraphScreen();
      case 2:
        return const ModuleTrackingScreen();
      case 3:
        return const TodoScreen();
      default:
        return const Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Side bar generator
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
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !profile.equals(Profile.blankProfile())) {
          return Scaffold(
            drawer: Drawer(
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
              profile,
            ),
          );
        }
        return Scaffold(
          body: const Center(
            child: SizedBox(
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ),
          appBar: AppBar(
            title: const Text('HelpUS'),
          ),
        );
      },
    );
  }

  // Checks if user already has profile. If it doesn't, creates a new one. Else,
  // obtain data from firestore.
  Future<bool> checkProfile() async {
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
        'moduleGrading': [],
        'todoList': [],
        'labels': Labels(Labels.defaultTags).toJson(),
      });
    }
    await Profile.generate(user.uid, profile);
    return true;
  }
}

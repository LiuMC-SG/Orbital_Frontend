import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpus/utilities/constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          ListTile(
            leading: const Icon(
              Icons.account_circle_rounded,
            ),
            title: const Text(
              'Profile',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_rounded,
            ),
            title: const Text(
              'Settings',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.backup_table,
            ),
            title: const Text(
              'Main Page',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.book_rounded,
            ),
            title: const Text(
              'Module Tracking',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.view_carousel_rounded,
            ),
            title: const Text(
              'Module Generation',
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app_rounded,
            ),
            title: const Text(
              'Logout',
            ),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Future.delayed(Duration.zero, () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesText.signIn,
        (route) => false,
      );
    });
  }
}

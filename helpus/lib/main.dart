import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:helpus/firebase_options.dart';
import 'package:helpus/models/recaptcha/recaptcha_service.dart';
import 'package:helpus/secrets.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/utilities/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialise recaptcha
  await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: Config.siteKey);
  if (kIsWeb) {
    await RecaptchaService.initiate();
  }

  // Enable persistence of firebase data
  if (kIsWeb) {
    await FirebaseFirestore.instance.enablePersistence(
      const PersistenceSettings(
        synchronizeTabs: true,
      ),
    );
  } else {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpUS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[50],
          foregroundColor: Colors.cyan[800],
        ),
        primarySwatch: Colors.teal,
      ),
      initialRoute: RoutesText.signIn,
      onGenerateRoute: Routes.onGenerateRoutes,
    );
  }
}

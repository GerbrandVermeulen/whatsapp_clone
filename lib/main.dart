import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/screens/home/home.dart';
import 'package:whatsapp_clone/screens/login/create_profile.dart';
import 'package:whatsapp_clone/screens/login/welcome.dart';
import 'package:whatsapp_clone/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  runApp(const MainApp());
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 92, 208, 111),
    surface: Colors.white,
  ),
  fontFamily: 'Helvatica',
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsUpp',
      theme: theme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (!snapshot.hasData) {
              return const WelcomeScreen();
            }

            final user = snapshot.data;
            if (user!.displayName == null) {
              return const CreateProfileScreen();
            }

            return const HomeScreen();
          }),
    );
  }
}

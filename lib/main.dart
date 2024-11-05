import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/providers/conversation_provider.dart';
import 'package:whatsapp_clone/providers/user_auth_provider.dart';
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
  runApp(const ProviderScope(child: MainApp()));
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 92, 208, 111),
    surface: Colors.white,
  ),
  fontFamily: 'Helvatica',
);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userAuthProvider);

    ref.read(conversationStreamProvider.future);

    return MaterialApp(
      title: 'WhatsUpp',
      theme: theme,
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const WelcomeScreen();
          }

          if (user.displayName == null) {
            return const CreateProfileScreen();
          }

          return const HomeScreen();
        },
        loading: () => const SplashScreen(),
        error: (error, stackTrace) => const SplashScreen(),
      ),
    );
  }
}

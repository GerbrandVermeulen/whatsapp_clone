import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/providers/contact_provider.dart';
import 'package:whatsapp_clone/providers/conversation_provider.dart';
import 'package:whatsapp_clone/providers/user_auth_provider.dart';
import 'package:whatsapp_clone/screens/home/home.dart';
import 'package:whatsapp_clone/screens/login/create_profile.dart';
import 'package:whatsapp_clone/screens/login/welcome.dart';
import 'package:whatsapp_clone/screens/splash.dart';
import 'package:whatsapp_clone/util/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends ConsumerState<MainApp> {
  UserSessionManager? userSessionManager;

  void _startUserSession(String userId) {
    userSessionManager = UserSessionManager(userId);
    userSessionManager!.startSessionTimer();
    _resetProviders(ref);
  }

  void _stopUserSession() {
    if (userSessionManager != null) {
      userSessionManager!.stopSessionTimer();
    }
  }

  void _resetProviders(WidgetRef ref) {
    ref.invalidate(conversationStreamProvider);
    ref.invalidate(latestMessageProvider);
    ref.invalidate(unreadCounterProvider);
    ref.invalidate(contactProvider);
    ref.read(conversationStreamProvider.future);
    ref.read(contactProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userAuthProvider);

    return MaterialApp(
      title: 'WhatsUpp',
      theme: theme,
      home: authState.when(
        data: (user) {
          _stopUserSession();
          if (user == null) {
            return const WelcomeScreen();
          }

          if (user.displayName == null) {
            return const CreateProfileScreen();
          }

          _startUserSession(user.uid);
          return const HomeScreen();
        },
        loading: () => const SplashScreen(),
        error: (error, stackTrace) => const SplashScreen(),
      ),
    );
  }
}

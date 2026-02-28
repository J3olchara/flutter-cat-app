import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/cat_provider.dart';
import 'screens/tab_bar_screen.dart';
import 'services/firebase_messaging_service.dart';
import 'services/app_lifecycle_service.dart';

late AppLifecycleService _lifecycleService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();
  
  _lifecycleService = AppLifecycleService(messagingService.localNotifications);
  
  messagingService.scheduleWelcomeNotification(delaySeconds: 15);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatProvider(),
      child: MaterialApp(
        title: 'Кототиндер',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        home: const TabBarScreen(),
      ),
    );
  }
}

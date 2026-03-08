import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/screens/auth_wrapper_screen.dart';
import 'services/firebase_messaging_service.dart';
import 'services/app_lifecycle_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final di = InjectionContainer();
  di.init();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  AppLifecycleService(messagingService.localNotifications);

  messagingService.scheduleWelcomeNotification(delaySeconds: 15);

  runApp(MyApp(di: di));
}

class MyApp extends StatelessWidget {
  final InjectionContainer di;

  const MyApp({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.createAuthProvider()),
        ChangeNotifierProvider(create: (_) => di.createCatProvider()),
      ],
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
        navigatorObservers: [di.analyticsService.getAnalyticsObserver()],
        home: AuthWrapperScreen(analyticsService: di.analyticsService),
      ),
    );
  }
}

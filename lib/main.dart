import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhurandhar/providers/event_like_provider.dart';
import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/providers/onboarding_tour_provider.dart';
import 'package:dhurandhar/providers/mobile_auth_provider.dart';
import 'package:dhurandhar/providers/post_event_provider.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/appTheme.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/get_it/locator.dart';
import 'package:dhurandhar/utils/router.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/main_screen/noInternetScreen.dart';
import 'package:dhurandhar/views/main_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

bool isCurrentlyOnNoInternet = false;
final navigatorKey = GlobalKey<NavigatorState>();
get getContext => navigatorKey.currentState?.overlay?.context;

void main() async {
  await InitializeApp.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // String? savedLanguageCode;

  // MyApp(this.savedLanguageCode, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Locale _currentLocale;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    init();
    
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    connectivitySubscription.cancel();
  }

  void init() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        launchScreen(
            navigatorKey.currentState!.overlay!.context, const NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          Navigator.pop(navigatorKey.currentState!.overlay!.context);
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected.');
        }
        log('connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingTourProvider()),
        ChangeNotifierProvider(create: (_) => MobileAuthenicationProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => PostEventProvider()),
        ChangeNotifierProvider(create: (_) => ProfileScreenProvider()),
        ChangeNotifierProvider(create: (_) => EventLikeProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "Dhurandhar",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const SplashScreen(),
        // theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}

class InitializeApp {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Initilizing firebase
    await Firebase.initializeApp( options:
      const FirebaseOptions(
      apiKey: 'AIzaSyAk4qGi5fpkk584hMZk57skpJT-g-gRx5c',
      appId: '1:460391389322:android:a9a2ba6f0072ea76ccf573',
      messagingSenderId: '460391389322',
      projectId: 'dhurandhar-3cb06',
    )
      // options: DefaultFirebaseOptions.currentPlatform
      );

    // Pass all uncaught errors from the framework to Crashlytics.
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    // if (kDebugMode) {
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    // }

    // Initilizing ConnectionStatus
    // ConnectionStatus().initialize();

    setupLocator();

    // Initilizing CustomLogger
    CustomLogger.init();
    // await locator<DBService>().open();
  }
}

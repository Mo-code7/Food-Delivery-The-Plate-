import 'package:delivery_food_app/common/color_extension.dart';
import 'package:delivery_food_app/firebase_options.dart';
import 'package:delivery_food_app/view/login/welcome_view.dart';
import 'package:delivery_food_app/view/main_tabview/main_tabview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp(
    defaultHome: WelcomeView(),
  ));
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Plate',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: TColor.primary,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: TColor.primaryText),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: TColor.primaryText),
          bodyMedium: TextStyle(color: TColor.primaryText),
        ),
      ),
      home: FutureBuilder<String?>(
        future: getToken(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainTabView();
          } else {
            return const WelcomeView();
          }
        },
      ),
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}

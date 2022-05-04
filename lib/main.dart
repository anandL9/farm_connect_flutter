import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:farm_connect_salesmen/screens/home_page.dart';
import 'package:farm_connect_salesmen/screens/login_page.dart';
import 'package:farm_connect_salesmen/utils/pref_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Connect',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: AnimatedSplashScreen(
        duration: 1000,
        splash: Image.asset(
          'assets/farm_connect_logo.png',
        ),
        splashIconSize: 400,
        nextScreen: FutureBuilder<String?>(
            future: getUserData(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            }),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.black38,
      ),
      routes: <String, WidgetBuilder>{
        'homePage': (BuildContext context) => const HomePage(),
        'loginPage': (BuildContext context) => const LoginPage()
      },
    );
  }
}

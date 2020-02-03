import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waka/ui/my_colors.dart';
import 'package:waka/ui/screens/login_screen.dart';
import 'package:waka/ui/screens/user_activity_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  Widget page = await checkFirstLaunch();
  runApp(MyApp(page: page));
}

class MyApp extends StatelessWidget {
  final Widget page;

  const MyApp({Key key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MyColors.MAIN_COLOR,
        textTheme: TextTheme(
          title: TextStyle(
            color: MyColors.BLACK_COLOR,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          body1: TextStyle(
            color: MyColors.BLACK_COLOR,
            fontSize: 14,
          ),
          body2: TextStyle(
            color: MyColors.txtColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          display1: TextStyle(
            color: MyColors.WHITE_COLOR,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          display2: TextStyle(
            color: MyColors.txtColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              color: MyColors.WHITE_COLOR,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: page,
    );
  }
}

Future<Widget> checkFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn)
    return UserActivityScreen();
  else
    return LoginScreen();
}

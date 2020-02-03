import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waka/repository/remote/http.dart';
import 'package:waka/ui/background.dart';
import 'package:waka/ui/login_card.dart';
import 'package:waka/ui/my_colors.dart';
import 'package:waka/ui/register_card.dart';
import 'package:waka/ui/screens/user_activity_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final apiKeyRegisterCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/hello-there.png'),
                ),
                SizedBox(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(20.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: LoginCard(
                        userLoginCtrl: apiKeyRegisterCtrl,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    _login(apiKeyRegisterCtrl.text);
                  },
                  textColor: MyColors.WHITE_COLOR,
                  color: MyColors.darkBackgroundColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    "Let's Go",
                    style: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .title
                        .copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login(String apiKey) async {
          await SharedPreferences.getInstance()
            ..setString("apiKey", apiKey)
            ..setBool('isLoggedIn', true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserActivityScreen(),
            ),
          );
  }

  _showToast(String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: MyColors.darkBackgroundColor,
      textColor: MyColors.WHITE_COLOR,
      fontSize: 16.0,
    );
  }
}

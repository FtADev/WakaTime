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
  final userLoginCtrl = TextEditingController();
  final passLoginCtrl = TextEditingController();
  final apiKeyRegisterCtrl = TextEditingController();
  final userRegisterCtrl = TextEditingController();
  final passRegisterCtrl = TextEditingController();
  final rePassRegisterCtrl = TextEditingController();
  bool loginPage = true;

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
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-8 / 360),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(20.0),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(10 / 360),
                          child: AnimatedCrossFade(
                            crossFadeState: loginPage
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: Duration(milliseconds: 300),
                            firstChild: LoginCard(
                              userLoginCtrl: userLoginCtrl,
                              passLoginCtrl: passLoginCtrl,
                            ),
                            secondChild: RegisterCard(
                              apiKeyRegisterCtrl: apiKeyRegisterCtrl,
                              userRegisterCtrl: userRegisterCtrl,
                              passRegisterCtrl: passRegisterCtrl,
                              rePassRegisterCtrl: rePassRegisterCtrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    loginPage
                        ? _login(userLoginCtrl.text, passLoginCtrl.text)
                        : _register(
                            apiKeyRegisterCtrl.text,
                            userRegisterCtrl.text,
                            passRegisterCtrl.text,
                            rePassRegisterCtrl.text);
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
                FlatButton(
                  child: Text(
                    loginPage ? "Sign Up" : "Sign In",
                    style: Theme.of(context).textTheme.body2,
                  ),
                  onPressed: () {
                    setState(() {
                      loginPage = !loginPage;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login(String username, String password) {
    login(username, password).then(
      (user) async {
        if (user.userId != null) {
          await SharedPreferences.getInstance()
            ..setString("userId", user.userId)
            ..setString("fullName", user.fullName)
            ..setString("team", user.team)
            ..setString("apiKey", user.apiKey)
            ..setBool('isLoggedIn', true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserActivityScreen(),
            ),
          );
        } else
          _showToast("Please Try Again!");
      },
    );
  }

  _register(String apiKey, String username, String password, String rePass) {
    password == rePass
        ? register(apiKey, username, password).then(
            (user) async {
              if (user.userId != null) {
                await SharedPreferences.getInstance()
                  ..setString("userId", user.userId)
                  ..setString("fullName", user.fullName)
                  ..setString("team", user.team)
                  ..setString("apiKey", user.apiKey)
                  ..setBool('isLoggedIn', true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => UserActivityScreen(),
                  ),
                );
              } else
                _showToast("Please Try Again!");
            },
          )
        : _showToast("Password & Re-Password NOT Mached!");
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

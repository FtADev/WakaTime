import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyScreen extends StatelessWidget {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.lime),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Hello There!",
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
              SizedBox(height: 8),
              Text(
                "Please Enter Your API Key:",
                style: Theme.of(context).textTheme.body2,
              ),
              SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _textEditingController,
                  cursorColor: Colors.lime[800],
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              RaisedButton(
                onPressed: () {
//                  login(_textEditingController.text).then(
//                    (user) async {
//                      if (user.userId != null) {
//                        await SharedPreferences.getInstance()
//                          ..setString("userId", user.userId)
//                          ..setString("fullName", user.fullName)
//                          ..setString("team", user.team)
//                          ..setString("apiKey", user.apiKey)
//                          ..setBool('isLoggedIn', true);
//                        Navigator.of(context).pushReplacement(
//                          MaterialPageRoute(
//                            builder: (context) => ActivityScreen(),
//                          ),
//                        );
//                      } else
//                        Fluttertoast.showToast(
//                          msg: "Please Try Again!",
//                          toastLength: Toast.LENGTH_SHORT,
//                          gravity: ToastGravity.BOTTOM,
//                          timeInSecForIos: 1,
//                          backgroundColor: Colors.lime[800],
//                          textColor: Colors.white,
//                          fontSize: 16.0,
//                        );
//                    },
//                  );
                },
                textColor: Colors.white,
                color: Colors.lime[800],
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Let's Go",
                  style: Theme.of(context).appBarTheme.textTheme.title.copyWith(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

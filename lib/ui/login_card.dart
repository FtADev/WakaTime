import 'package:flutter/material.dart';
import 'package:waka/ui/my_colors.dart';

class LoginCard extends StatelessWidget {
  final userLoginCtrl;

  const LoginCard(
      {Key key, @required this.userLoginCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: userLoginCtrl,
          cursorColor: MyColors.darkBackgroundColor,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: MyColors.txtColor),
          decoration: InputDecoration(labelText: "Please Enter Your ApiKey"),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

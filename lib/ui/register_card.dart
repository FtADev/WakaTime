import 'package:flutter/material.dart';
import 'package:waka/ui/my_colors.dart';

class RegisterCard extends StatelessWidget {
  final apiKeyRegisterCtrl;
  final userRegisterCtrl;
  final passRegisterCtrl;
  final rePassRegisterCtrl;

  const RegisterCard(
      {Key key,
      @required this.apiKeyRegisterCtrl,
      @required this.userRegisterCtrl,
      @required this.passRegisterCtrl,
      @required this.rePassRegisterCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: apiKeyRegisterCtrl,
          cursorColor: MyColors.darkBackgroundColor,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: MyColors.txtColor),
          decoration: InputDecoration(labelText: "Api Key"),
        ),
        TextField(
          controller: userRegisterCtrl,
          cursorColor: MyColors.darkBackgroundColor,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: MyColors.txtColor),
          decoration: InputDecoration(labelText: "Username"),
        ),
        TextField(
          controller: passRegisterCtrl,
          cursorColor: MyColors.darkBackgroundColor,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: MyColors.txtColor),
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        TextField(
          controller: rePassRegisterCtrl,
          cursorColor: MyColors.darkBackgroundColor,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: MyColors.txtColor),
          decoration: InputDecoration(labelText: "Re-Password"),
          obscureText: true,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

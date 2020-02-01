import 'package:flutter/material.dart';
import 'package:waka/repository/model/user.dart';
import 'package:waka/ui/activity_chart.dart';
import 'package:waka/ui/language_chart.dart';

class UserActivityScreen extends StatefulWidget {
  final User user;

  const UserActivityScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _UserActivityScreenState createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exp Waka"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ActivityChart(
              user: widget.user,
            ),
            LanguageChart(
              dataList: widget.user.userData.data,
            )
          ],
        ),
      ),
    );
  }
}

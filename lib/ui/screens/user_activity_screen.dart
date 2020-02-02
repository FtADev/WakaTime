import 'package:flutter/material.dart';
import 'package:waka/repository/model/data.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/repository/remote/http.dart';
import 'package:waka/ui/activity_chart.dart';
import 'package:waka/ui/language_chart.dart';

class UserActivityScreen extends StatefulWidget {
  @override
  _UserActivityScreenState createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  UserData userData;
  double totalSec = 0;
  double totalSeconds;
  String totalTimeString;

  @override
  initState() {
    _getUserSummary("APIKEY", "2020-01-27", "2020-02-02");
    super.initState();
  }

  _calculateTimes(UserData userData) {
      for (Data data in userData.data)
        totalSec +=
        data.categories.isNotEmpty ? data.categories[0].totalSeconds : 0;
      var dur = Duration(seconds: totalSec.toInt());
      int hrs = dur.inHours;
      int mins = dur.inMinutes.remainder(60);
      String timeString = hrs > 0
          ? "$hrs hrs ${mins.toString()} mins"
          : "${mins.toString()} mins";
      totalSeconds = totalSec;
      totalTimeString = timeString;
  }

  _getUserSummary(String apiKey, String start, String end) {
    getUserSummary(apiKey, start, end).then((response) {
      setState(() {
        userData = response;
        _calculateTimes(response);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WakaTime"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            (userData != null) ?
            ActivityChart(
              userData: userData,
              totalTimeString: totalTimeString,
            ) : Container(),
            (userData != null) ?
            LanguageChart(
              dataList: userData.data,
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

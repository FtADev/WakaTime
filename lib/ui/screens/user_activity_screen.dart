import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waka/repository/model/data.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/repository/remote/http.dart';
import 'package:waka/ui/activity_chart.dart';
import 'package:waka/ui/editor_chart.dart';
import 'package:waka/ui/language_chart.dart';
import 'package:waka/ui/os_chart.dart';

class UserActivityScreen extends StatefulWidget {
  @override
  _UserActivityScreenState createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  final GlobalKey<LanguageChartState> languageState = GlobalKey<LanguageChartState>();
  final GlobalKey<EditorChartState> editorState = GlobalKey<EditorChartState>();
  final GlobalKey<OSChartState> osState = GlobalKey<OSChartState>();
  UserData userData;
  double totalSec = 0;
  double totalSeconds;
  String totalTimeString;
  bool is7Day = true;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      String apiKey = prefs.getString('apiKey');
      String start = is7Day ? DateFormat('yyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 6)))
      : DateFormat('yyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 13)));
      String end = DateFormat('yyy-MM-dd').format(DateTime.now());
      _getUserSummary(apiKey, start, end);
    });
    super.initState();
  }

  _calculateTimes(UserData userData) {
    totalSec = 0;
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

  updateCharts() {
    languageState.currentState.buildChart();
    editorState.currentState.buildChart();
    osState.currentState.buildChart();
  }

  changeDate() {
    setState(() {
      is7Day = !is7Day;
      SharedPreferences.getInstance().then((prefs) {
        String apiKey = prefs.getString('apiKey');
        String start = is7Day ? DateFormat('yyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: 6)))
            : DateFormat('yyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: 13)));
        String end = DateFormat('yyy-MM-dd').format(DateTime.now());
        _getUserSummary(apiKey, start, end);
        updateCharts();
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
              changeDate: changeDate,
              is7Day: is7Day,
            ) : Container(),
            (userData != null) ?
            LanguageChart(
              key: languageState,
              userData: userData,
            ) : Container(),
            (userData != null) ?
            EditorChart(
              key: editorState,
              userData: userData,
            ) : Container(),
            (userData != null) ?
            OSChart(
              key: osState,
              userData: userData,
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

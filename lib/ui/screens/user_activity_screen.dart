import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GlobalKey<ActivityChartState> activityState =
      GlobalKey<ActivityChartState>();
  final GlobalKey<LanguageChartState> languageState =
      GlobalKey<LanguageChartState>();
  final GlobalKey<EditorChartState> editorState = GlobalKey<EditorChartState>();
  final GlobalKey<OSChartState> osState = GlobalKey<OSChartState>();
  UserData userData;
  bool is7Day = true;

  @override
  initState() {
    SharedPreferences.getInstance().then((prefs) {
      String apiKey = prefs.getString('apiKey');
      String start = is7Day
          ? DateFormat('yyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 6)))
          : DateFormat('yyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 13)));
      String end = DateFormat('yyy-MM-dd').format(DateTime.now());
      _getUserSummary(apiKey, start, end);
    });
    super.initState();
  }

  _getUserSummary(String apiKey, String start, String end) {
    getUserSummary(apiKey, start, end).then((response) {
      setState(() {
        userData = response;
      });
    });
  }

  updateCharts(UserData userData) {
    activityState.currentState.buildChart(userData);
    languageState.currentState.buildChart(userData);
    editorState.currentState.buildChart(userData);
    osState.currentState.buildChart(userData);
  }

  changeDate() {
    setState(() {
      is7Day = !is7Day;
      SharedPreferences.getInstance().then((prefs) {
        String apiKey = prefs.getString('apiKey');
        String start = is7Day
            ? DateFormat('yyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: 6)))
            : DateFormat('yyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: 13)));
        String end = DateFormat('yyy-MM-dd').format(DateTime.now());
        getUserSummary(apiKey, start, end).then((response) {
          setState(() {
            userData = response;
          });
          updateCharts(userData);
        });
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
            (userData != null)
                ? ActivityChart(
                    key: activityState,
                    userData: userData,
                    changeDate: changeDate,
                    is7Day: is7Day,
                  )
                : Container(),
            (userData != null)
                ? LanguageChart(
                    key: languageState,
                    userData: userData,
                  )
                : Container(),
            (userData != null)
                ? EditorChart(
                    key: editorState,
                    userData: userData,
                  )
                : Container(),
            (userData != null)
                ? OSChart(
                    key: osState,
                    userData: userData,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waka/repository/model/data.dart';
import 'package:waka/repository/model/user.dart';
import 'package:waka/repository/model/users_activity.dart';
import 'package:waka/repository/remote/http.dart';
import 'package:waka/ui/activity_chart.dart';
import 'package:waka/ui/user_card.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<User> mUsersList = [];
  User mCurrentUser;

  @override
  initState() {
    super.initState();
    String start = DateFormat('yyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 6)));
    String end = DateFormat('yyy-MM-dd').format(DateTime.now());
    _getAllUsersActivity(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waka"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: mCurrentUser != null
                ? ActivityChart(
                    user: mCurrentUser,
                  )
                : Container(),
          ),
          Expanded(
            flex: 7,
            child: ListView.builder(
              itemCount: mUsersList.isNotEmpty ? mUsersList.length : 0,
              itemBuilder: (context, index) {
                return UserCard(
                  user: mUsersList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _getAllUsersActivity(String start, String end) {
    getAllUsersSummary(start, end).then((usersActivity) {
      setState(() {
        _setCurrentUserStatus(usersActivity);
        _calculateTimes(usersActivity);
        _sortUsers(mUsersList);
      });
    });
  }

  _setCurrentUserStatus(UsersActivity usersActivity) {
    SharedPreferences.getInstance().then((prefs) {
      String currentUserId = prefs.getString("userId");
      for (User user in mUsersList) {
        if (user.userId == currentUserId) {
          mCurrentUser = user;
          mCurrentUser.totalTimeString = user.totalTimeString;
          break;
        }
      }
    });
  }

  _calculateTimes(UsersActivity usersActivity) {
    for (User user in usersActivity.users) {
      double totalSec = 0;
      for (Data data in user.userData.data)
        totalSec +=
            data.categories.isNotEmpty ? data.categories[0].totalSeconds : 0;
      var dur = Duration(seconds: totalSec.toInt());
      int hrs = dur.inHours;
      int mins = dur.inMinutes.remainder(60);
      String timeString = hrs > 0
          ? "$hrs hrs ${mins.toString()} mins"
          : "${mins.toString()} mins";
      user.totalSeconds = totalSec;
      user.totalTimeString = timeString;
      mUsersList.add(user);
    }
  }

  _sortUsers(List<User> usersList) {
    for (int i = 0; i < usersList.length - 1; i++) {
      for (int j = i + 1; j < usersList.length; j++) {
        if (usersList[i].totalSeconds < usersList[j].totalSeconds) {
          User tmpS = usersList[i];
          usersList[i] = usersList[j];
          usersList[j] = tmpS;
        }
      }
    }
  }
}

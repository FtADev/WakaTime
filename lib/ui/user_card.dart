import 'package:flutter/material.dart';
import 'package:waka/repository/model/user.dart';
import 'package:waka/ui/my_colors.dart';
import 'package:waka/ui/screens/user_activity_screen.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key key, @required this.user})
      : super(key: key);

  Color _takeColor(String team) {
    switch (team) {
      case "Mobile":
        return MyColors.MOBILE_COLOR;
      case "Back":
        return MyColors.BACK_COLOR;
      case "Web":
        return MyColors.WEB_COLOR;
      default:
        return MyColors.OTHER_COLOR;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            user.fullName,
            style: Theme.of(context).textTheme.title,
          ),
          leading: CircleAvatar(
            backgroundColor: _takeColor(user.team),
            child: Text(
              user.fullName.substring(0, 1),
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          subtitle: Text(
            user.totalTimeString,
            style: Theme.of(context).textTheme.body1,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserActivityScreen(
                  user: user,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

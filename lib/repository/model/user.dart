import 'package:waka/repository/model/user_data.dart';

class User {
  String fullName;
  String humanReadableWebsite;
  String id;
  String location;
  String photo;
  String username;
  String website;
  String team;
  String apiKey;
  String userId;
  UserData userData;
  double totalSeconds;
  String totalTimeString;

  User(
      {this.fullName,
      this.humanReadableWebsite,
      this.id,
      this.location,
      this.photo,
      this.username,
      this.website,
      this.team,
      this.apiKey,
      this.userId,
      this.userData,
      this.totalSeconds,
      this.totalTimeString});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    humanReadableWebsite = json['human_readable_website'];
    id = json['id'];
    location = json['location'];
    photo = json['photo'];
    username = json['username'];
    website = json['website'];
    team = json['team'];
    apiKey = json['api_key'];
    userId = json['userId'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['human_readable_website'] = this.humanReadableWebsite;
    data['id'] = this.id;
    data['location'] = this.location;
    data['photo'] = this.photo;
    data['username'] = this.username;
    data['website'] = this.website;
    data['team'] = this.team;
    data['api_key'] = this.apiKey;
    data['userId'] = this.userId;
    if (this.userData != null) {
      data['userData'] = this.userData.toJson();
    }
    return data;
  }
}

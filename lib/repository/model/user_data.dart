import 'data.dart';

class UserData {
  List<Data> data;
  String end;
  String start;

  UserData({this.data, this.end, this.start});

  UserData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    end = json['end'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['end'] = this.end;
    data['start'] = this.start;
    return data;
  }
}

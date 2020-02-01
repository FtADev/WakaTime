class Range {
  String date;
  String end;
  String start;
  String text;
  String timezone;

  Range({this.date, this.end, this.start, this.text, this.timezone});

  Range.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    end = json['end'];
    start = json['start'];
    text = json['text'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['end'] = this.end;
    data['start'] = this.start;
    data['text'] = this.text;
    data['timezone'] = this.timezone;
    return data;
  }
}

class Categories {
  String digital;
  int hours;
  int minutes;
  String name;
  double percent;
  int seconds;
  String text;
  double totalSeconds;

  Categories(
      {this.digital,
      this.hours,
      this.minutes,
      this.name,
      this.percent,
      this.seconds,
      this.text,
      this.totalSeconds});

  Categories.fromJson(Map<String, dynamic> json) {
    digital = json['digital'];
    hours = json['hours'];
    minutes = json['minutes'];
    name = json['name'];
    percent = double.parse(json['percent'].toString());
    seconds = json['seconds'];
    text = json['text'];
    totalSeconds = double.parse(json['total_seconds'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['digital'] = this.digital;
    data['hours'] = this.hours;
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    data['percent'] = this.percent;
    data['seconds'] = this.seconds;
    data['text'] = this.text;
    data['total_seconds'] = this.totalSeconds;
    return data;
  }
}

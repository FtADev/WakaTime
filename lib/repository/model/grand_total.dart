class GrandTotal {
  String digital;
  int hours;
  int minutes;
  String text;
  double totalSeconds;

  GrandTotal(
      {this.digital, this.hours, this.minutes, this.text, this.totalSeconds});

  GrandTotal.fromJson(Map<String, dynamic> json) {
    digital = json['digital'];
    hours = json['hours'];
    minutes = json['minutes'];
    text = json['text'];
    totalSeconds = double.parse(json['total_seconds'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['digital'] = this.digital;
    data['hours'] = this.hours;
    data['minutes'] = this.minutes;
    data['text'] = this.text;
    data['total_seconds'] = this.totalSeconds;
    return data;
  }
}

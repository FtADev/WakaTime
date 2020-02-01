class Machines {
  String digital;
  int hours;
  String machineNameId;
  int minutes;
  String name;
  double percent;
  int seconds;
  String text;
  double totalSeconds;

  Machines(
      {this.digital,
      this.hours,
      this.machineNameId,
      this.minutes,
      this.name,
      this.percent,
      this.seconds,
      this.text,
      this.totalSeconds});

  Machines.fromJson(Map<String, dynamic> json) {
    digital = json['digital'];
    hours = json['hours'];
    machineNameId = json['machine_name_id'];
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
    data['machine_name_id'] = this.machineNameId;
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    data['percent'] = this.percent;
    data['seconds'] = this.seconds;
    data['text'] = this.text;
    data['total_seconds'] = this.totalSeconds;
    return data;
  }
}

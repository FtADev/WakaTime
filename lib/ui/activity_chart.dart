import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waka/repository/model/data.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/ui/my_colors.dart';

class ActivityChart extends StatefulWidget {
  final UserData userData;
  final Function changeDate;
  final bool is7Day;

  const ActivityChart({
    Key key,
    @required this.userData,
    this.changeDate,
    this.is7Day,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ActivityChartState();
}

class ActivityChartState extends State<ActivityChart> {
  final double width = 22;
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  double totalSec = 0;
  double totalSeconds;
  String totalTimeString;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  final Duration animDuration = Duration(milliseconds: 250);
  bool isPlaying = false;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    buildChart(widget.userData);
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
    print(totalTimeString);
  }

  buildChart(UserData userData) {
    _calculateTimes(userData);

    List<BarChartGroupData> items = [];
    for (int i = 0; i < userData.data.length; i++) {
      BarChartGroupData barGroup = makeGroupData(
          i,
          userData.data[i].categories.isNotEmpty
              ? userData.data[i].categories[0].totalSeconds / 3600
              : 0);
      items.add(barGroup);
    }

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    barTouchedResultStreamController = StreamController();
    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }

      if (response.spot == null) {
        setState(() {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        });
        return;
      }

      touchedGroupIndex =
          showingBarGroups.indexOf(response.spot.touchedBarGroup);

      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        } else {
          showingBarGroups = List.of(rawBarGroups);
          if (touchedGroupIndex != -1) {
            showingBarGroups[touchedGroupIndex] =
                showingBarGroups[touchedGroupIndex].copyWith(
              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                return rod.copyWith(
                    color: MyColors.BAR_TOUCHED_COLOR, y: rod.y + 1);
              }).toList(),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: MyColors.MAIN_COLOR,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  (totalTimeString != null) ? totalTimeString : "",
                  style: Theme.of(context).textTheme.body2,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    widget.changeDate();
                  },
                  child: Text(
                    widget.is7Day ? "7 Days Ago" : "14 Days Ago",
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: const Color(0xff0f4a3c),
                ),
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      refreshState();
                    }
                  });
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: const BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (double value) {
            return DateFormat.E()
                .format(DateTime.now().subtract(Duration(
                    days: widget.userData.data.length - 1 - value.toInt())))
                .substring(0, 1);
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(widget.userData.data.length, (i) {
        return makeGroupData(i, Random().nextInt(15).toDouble() + 6,
            barColor:
                availableColors[Random().nextInt(availableColors.length)]);
      }),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: MyColors.TOOLTIP_BG_COLOR,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = DateFormat.E().format(DateTime.now().subtract(Duration(
                  days: widget.userData.data.length - 1 - group.x.toInt())));
              return BarTooltipItem(
                  weekDay +
                      '\n' +
                      widget.userData.data[group.x.toInt()].categories[0].text,
                  TextStyle(color: MyColors.BAR_TOUCHED_COLOR));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedGroupIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedGroupIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: Theme.of(context).textTheme.body2.copyWith(fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return DateFormat.E()
                .format(DateTime.now().subtract(Duration(
                    days: widget.userData.data.length - 1 - value.toInt())))
                .substring(0, 1);
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        color: isTouched ? Colors.yellow : barColor,
        width: width,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 8,
          color: MyColors.darkBackgroundColor,
        ),
      ),
    ]);
  }

  List<BarChartGroupData> showingGroups() {
    List<BarChartGroupData> items = [];
    for (int i = 0; i < widget.userData.data.length; i++) {
      BarChartGroupData barGroup = makeGroupData(
          i,
          widget.userData.data[i].categories.isNotEmpty
              ? widget.userData.data[i].categories[0].totalSeconds / 3600
              : 0,
          isTouched: i == touchedGroupIndex);
      items.add(barGroup);
    }
    return items;
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }

  @override
  void dispose() {
    super.dispose();
    barTouchedResultStreamController.close();
  }
}

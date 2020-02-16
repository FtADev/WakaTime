import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/ui/my_colors.dart';

class ActivityChart extends StatefulWidget {
  final UserData userData;
  final String totalTimeString;
  final Function changeDate;
  final bool is7Day;

  const ActivityChart({
    Key key,
    @required this.userData,
    this.totalTimeString,
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

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  final Duration animDuration = Duration(milliseconds: 250);
  bool isPlaying = false;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    buildChart();
  }

  buildChart() {
    List<BarChartGroupData> items = [];
      for (int i = 0; i < (widget.is7Day ? 7 : 14); i++) {
        BarChartGroupData barGroup = makeGroupData(
            i,
            widget.userData.data[i].categories.isNotEmpty
                ? widget.userData.data[i].categories[0].totalSeconds / 3600
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
                  (widget.totalTimeString != null)
                      ? widget.totalTimeString
                      : "",
                  style: Theme.of(context).textTheme.body2,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    widget.changeDate();
                    setState(() {
                      buildChart();
                    });
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
            if(widget.is7Day) {
              switch (value.toInt()) {
                case 0:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 6)))
                      .substring(0, 1);
                case 1:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 5)))
                      .substring(0, 1);
                case 2:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 4)))
                      .substring(0, 1);
                case 3:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 3)))
                      .substring(0, 1);
                case 4:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 2)))
                      .substring(0, 1);
                case 5:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 1)))
                      .substring(0, 1);
                case 6:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 0)))
                      .substring(0, 1);
                default:
                  return '';
              }
            } else {
              switch (value.toInt()) {
                case 0:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 13)))
                      .substring(0, 1);
                case 1:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 12)))
                      .substring(0, 1);
                case 2:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 11)))
                      .substring(0, 1);
                case 3:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 10)))
                      .substring(0, 1);
                case 4:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 9)))
                      .substring(0, 1);
                case 5:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 8)))
                      .substring(0, 1);
                case 6:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 7)))
                      .substring(0, 1);
                case 7:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 6)))
                      .substring(0, 1);
                case 8:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 5)))
                      .substring(0, 1);
                case 9:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 4)))
                      .substring(0, 1);
                case 10:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 3)))
                      .substring(0, 1);
                case 11:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 2)))
                      .substring(0, 1);
                case 12:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 1)))
                      .substring(0, 1);
                case 13:
                  return DateFormat.E()
                      .format(DateTime.now().subtract(Duration(days: 0)))
                      .substring(0, 1);
                default:
                  return '';
              }
            }

          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor:
                    availableColors[Random().nextInt(availableColors.length)]);
          default:
            return null;
        }
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
              if(widget.is7Day) {
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 6)));
                    break;
                  case 1:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 5)));
                    break;
                  case 2:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 4)));
                    break;
                  case 3:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 3)));
                    break;
                  case 4:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 2)));
                    break;
                  case 5:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 1)));
                    break;
                  case 6:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 0)));
                    break;
                }
              } else {
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 13)));
                    break;
                  case 1:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 12)));
                    break;
                  case 2:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 11)));
                    break;
                  case 3:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 10)));
                    break;
                  case 4:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 9)));
                    break;
                  case 5:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 8)));
                    break;
                  case 6:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 7)));
                    break;
                  case 7:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 6)));
                    break;
                  case 8:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 5)));
                    break;
                  case 9:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 4)));
                    break;
                  case 10:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 3)));
                    break;
                  case 11:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 2)));
                    break;
                  case 12:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 1)));
                    break;
                  case 13:
                    weekDay = DateFormat.E()
                        .format(DateTime.now().subtract(Duration(days: 0)));
                    break;
                }
              }
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
            switch (value.toInt()) {
              case 0:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 6)))
                    .substring(0, 1);
              case 1:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 5)))
                    .substring(0, 1);
              case 2:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 4)))
                    .substring(0, 1);
              case 3:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 3)))
                    .substring(0, 1);
              case 4:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 2)))
                    .substring(0, 1);
              case 5:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 1)))
                    .substring(0, 1);
              case 6:
                return DateFormat.E()
                    .format(DateTime.now().subtract(Duration(days: 0)))
                    .substring(0, 1);
              default:
                return '';
            }
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
    for (int i = 0; i < (widget.is7Day ? 7: 14); i++) {
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

import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/ui/my_colors.dart';

class ActivityChart extends StatefulWidget {
  final UserData userData;
  final String totalTimeString;

  const ActivityChart({
    Key key,
    @required this.userData, this.totalTimeString,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ActivityChartState();
}

class ActivityChartState extends State<ActivityChart> {
  final double width = 22;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();

    List<BarChartGroupData> items = [];
    for (int i = 0; i < 7; i++) {
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
                return rod.copyWith(color: MyColors.BAR_TOUCHED_COLOR, y: rod.y + 1);
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
//              Text(
//                widget.user.fullName,
//                style: Theme.of(context).appBarTheme.textTheme.title,
//              ),
//              SizedBox(
//                height: 4,
//              ),
              Text(
                (widget.totalTimeString != null) ? widget.totalTimeString : "",
                style: Theme.of(context).textTheme.body2,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlChart(
                    chart: BarChart(BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: TouchTooltipData(
                            tooltipBgColor: MyColors.TOOLTIP_BG_COLOR,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                String weekDay;
                                switch (touchedSpot.spot.x.toInt()) {
                                  case 0:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 6)));
                                    break;
                                  case 1:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 5)));
                                    break;
                                  case 2:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 4)));
                                    break;
                                  case 3:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 3)));
                                    break;
                                  case 4:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 2)));
                                    break;
                                  case 5:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 1)));
                                    break;
                                  case 6:
                                    weekDay = DateFormat.E()
                                        .format(DateTime.now()
                                        .subtract(Duration(days: 0)));
                                    break;
                                }
                                return TooltipItem(
                                    weekDay +
                                        '\n' +
                                        widget.userData.data[touchedSpot.spot.x.toInt()].categories[0].text,
                                    TextStyle(color: MyColors.BAR_TOUCHED_COLOR));
                              }).toList();
                            }),
                        touchResponseSink:
                            barTouchedResultStreamController.sink,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                            showTitles: true,
                            textStyle: Theme.of(context).textTheme.body2.copyWith(fontSize: 14),
                            margin: 16,
                            // ignore: missing_return
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 6)))
                                      .substring(0, 1);
                                case 1:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 5)))
                                      .substring(0, 1);
                                case 2:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 4)))
                                      .substring(0, 1);
                                case 3:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 3)))
                                      .substring(0, 1);
                                case 4:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 2)))
                                      .substring(0, 1);
                                case 5:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 1)))
                                      .substring(0, 1);
                                case 6:
                                  return DateFormat.E()
                                      .format(DateTime.now()
                                      .subtract(Duration(days: 0)))
                                      .substring(0, 1);
                              }
                            }),
                        leftTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y,
        color: MyColors.WHITE_COLOR,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 8,
          color: MyColors.darkBackgroundColor,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    barTouchedResultStreamController.close();
  }
}

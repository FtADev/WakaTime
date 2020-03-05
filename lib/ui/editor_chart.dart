import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waka/repository/model/data.dart';
import 'package:waka/repository/model/editors.dart';
import 'package:waka/ui/indicator.dart';

import '../repository/model/user_data.dart';


class EditorChart extends StatefulWidget {
  final UserData userData;

  const EditorChart({Key key, this.userData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditorChartState();
}

class EditorChartState extends State<EditorChart> {
  List<PieChartSectionData> pieChartRawSections = [];
  List<PieChartSectionData> showingSections;
  List<String> editorsNames = [];
  List<double> totalSecond = [];
  double sum = 0.0;
  StreamController<PieTouchResponse> pieTouchedResultStreamController;
  int touchedIndex;

  List<MaterialColor> colorList = [
    Colors.orange,
    Colors.pink,
    Colors.yellow,
    Colors.lightBlue,
    Colors.purple,
    Colors.indigo,
    Colors.lightGreen,
    Colors.lime,
    Colors.brown,
    Colors.cyan,
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.grey
  ];

  buildChart() {
    pieChartRawSections = [];
    editorsNames = [];
    totalSecond = [];
    sum = 0.0;

    //Add all languages to list
    for (Data data in widget.userData.data)
      for (Editors lang in data.editors)
        if (!editorsNames.contains(lang.name)) editorsNames.add(lang.name);

    //Create a list of second, matches to languages list
    for (int i = 0; i < editorsNames.length; i++) totalSecond.add(0.0);

    for (int i = 0; i < editorsNames.length; i++) {
      for (int j = 0; j < widget.userData.data.length; j++) {
        for (int k = 0; k < widget.userData.data[j].editors.length; k++) {
          if (widget.userData.data[j].editors[k].name == editorsNames[i]) {
            totalSecond[i] += widget.userData.data[j].editors[k].totalSeconds;
          }
        }
      }
      sum += totalSecond[i];
    }

    //Sort
    for (int i = 0; i < editorsNames.length - 1; i++) {
      for (int j = i + 1; j < editorsNames.length; j++) {
        if (totalSecond[i] < totalSecond[j]) {
          double tmpS = totalSecond[i];
          totalSecond[i] = totalSecond[j];
          totalSecond[j] = tmpS;

          String tmpN = editorsNames[i];
          editorsNames[i] = editorsNames[j];
          editorsNames[j] = tmpN;
        }
      }
    }

    for (int i = 0; i < totalSecond.length; i++)
      pieChartRawSections.add(
        PieChartSectionData(
          color: colorList[i].withOpacity(0.8),
          value: totalSecond[i] / sum,
          title: "",
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
          ),
        ),
      );

    showingSections = pieChartRawSections;

    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) return;
      if (showingSections.indexOf(details.touchedSection) == -1) return;


      if (details.touchedSection != null)
        touchedIndex = showingSections.indexOf(details.touchedSection);
      print(touchedIndex);
      setState(() {
        showingSections = List.of(pieChartRawSections);

        double x = totalSecond[touchedIndex] / 3600;
        int hrs = x.floor();
        int mins = ((x - hrs) * 60).floor();
        final TextStyle style = showingSections[touchedIndex].titleStyle;
        showingSections[touchedIndex] = showingSections[touchedIndex].copyWith(
          title: hrs > 0
              ? "$hrs hrs ${mins.toString()} mins"
              : "${mins.toString()} mins",
          color: showingSections[touchedIndex].color.withOpacity(1),
          titleStyle: style.copyWith(fontSize: 14, color: Colors.black),
          radius: 60,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    buildChart();
  }

  List<Widget> _indicators() {
    List<Widget> indicators = [];
    indicators.add(SizedBox(height: 10));
    for (int i = 0; i < editorsNames.length; i++) {
      indicators.add(
        Indicator(
          color:
          touchedIndex == i ? colorList[i] : colorList[i].withOpacity(0.8),
          text: editorsNames[i],
          isSquare: false,
          size: touchedIndex == i ? 18 : 14,
          textColor: touchedIndex == i ? Colors.black : Colors.grey,
        ),
      );
      indicators.add(SizedBox(height: 5));
    }
    indicators.add(SizedBox(height: 10));
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback:
                          (pieTouchResponse) {
                        if (pieTouchResponse == null) return;
                        if (showingSections.indexOf(pieTouchResponse.touchedSection) == -1) return;

                        if (pieTouchResponse.touchedSection != null)
                          touchedIndex = showingSections.indexOf(pieTouchResponse.touchedSection);
                        print(touchedIndex);
                        setState(() {
                          showingSections = List.of(pieChartRawSections);

                          double x = totalSecond[touchedIndex] / 3600;
                          int hrs = x.floor();
                          int mins = ((x - hrs) * 60).floor();
                          final TextStyle style = showingSections[touchedIndex].titleStyle;
                          showingSections[touchedIndex] = showingSections[touchedIndex].copyWith(
                            title: hrs > 0
                                ? "$hrs hrs ${mins.toString()} mins"
                                : "${mins.toString()} mins",
                            color: showingSections[touchedIndex].color.withOpacity(1),
                            titleStyle: style.copyWith(fontSize: 14, color: Colors.black),
                            radius: 60,
                          );
                        });
                      }),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _indicators(),
          ),
          SizedBox(width: 28),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pieTouchedResultStreamController.close();
  }
}

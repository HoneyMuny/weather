import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import '../clases/datos.dart';

class Grafico4 extends StatefulWidget {
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<Grafico4> {
  final limitCount = 100;
  final tempPoints = <FlSpot>[];
  final humPoints = <FlSpot>[];
  /////////
  List<Datos> grafDat = <Datos>[];
  /////////

  double xValue = 0;
  int i = 0;
  double step = 0.05;

  late Timer timer;

  @override
  void initState() {
    super.initState();
   getDataFromFireStore().then((results) {
     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    timer = Timer.periodic(Duration(milliseconds: 80), (timer) {
          while (tempPoints.length > limitCount) {
            tempPoints.removeAt(0);
            humPoints.removeAt(0);
          }
          setState(() {
            tempPoints.add(FlSpot(xValue, grafDat[i].Temperatura));
            humPoints.add(FlSpot(xValue,grafDat[i].Humedad));
          });
          xValue += step;
         i++;
        });
      });
    });
  }

 Future<void> getDataFromFireStore() async {
    var snapShotsValue =
    await FirebaseFirestore.instance.collection('variablesTH').get();
    List<Datos> list = snapShotsValue.docs
        .map((e) {
      return Datos(e.data()["temperatura"],e.data()["humedad"]);
    }).toList();
    setState(() {
      grafDat = list;
    });
    print("====================="+grafDat[0].Temperatura.toString());
  }

  @override
  Widget build(BuildContext context) {
    return buildgraf(context);
  }
///////////

  @override
  Widget buildgraf(BuildContext context) {
    return tempPoints.isNotEmpty
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      /*  Text(
          'x: ${xValue.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),*/
        Text(
          'Humedad: ${humPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Temperatura: ${tempPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(
          height: 12,
        ),
        Container(
          width: 500,
          height: 500,
          child: LineChart(
            LineChartData(
              minY: 0,//Points.first.y,
              maxY: 100,//Points.first.y,
              minX: 0,//Points.first.x,
              maxX: 1,//Points.last.x,
              lineTouchData: LineTouchData(enabled: true),
              clipData: FlClipData.all(),
              gridData: FlGridData(
                show: true,
              ),
              lineBarsData: [
                tempLine(tempPoints),
                humLine(humPoints),
              ],
              titlesData: FlTitlesData(
                show: true,
                //bottomTitles: SideTitles(
                //  showTitles: false,
                ),
              ),
            ),
          ),

      ],
    )
        : Container();
  }

  LineChartBarData tempLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: true,
      ),
      color: Colors.amber, //[sinColor.withOpacity(0), sinColor],
      //colorStops: [0.1, 1.0],
      barWidth: 4,
      isCurved: false,
    );
  }

  LineChartBarData humLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: true,
      ),
      color: Colors.cyan,//[cosColor.withOpacity(0), cosColor],
      //colorStops: [0.1, 1.0],
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
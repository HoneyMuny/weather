import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Grafico3 extends StatefulWidget {
 
  Grafico3({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Grafico3> {

  List< _variablesData> data = < _variablesData>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((String) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
    await FirebaseFirestore.instance.collection('variablesTH').get();
    List<_variablesData> data1 = snapShotsValue.docs
        .map((e) {
      return  _variablesData((e.data()['Fecha']),(e.data()['Temperatura']));
    })
        .toList();
    setState(() {
      data = data1;
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Temperaturas'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
             // title: ChartTitle(text: ' Fecha/Temperaturas'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_variablesData, String>>[
                LineSeries<_variablesData, String>(
                    dataSource: data,
                    xValueMapper: (_variablesData datos, _) => datos.year,
                    yValueMapper: (_variablesData datos, _) => datos.datos,
                    name: 'Temperatura',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].datos,
                dataCount: 5,
              ),
            ),
          )
        ]));
  }
}

class _variablesData {
  _variablesData(this.year, this.datos);
  final String year;
  final double datos;
}
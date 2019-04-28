import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'sensor.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Observation {
  final String id;
  final double batteryVoltage;
  final int moisture;
  final Timestamp timestamp;
  final DocumentReference reference;

  Observation.fromMap(String id, Map<String, dynamic> map, {this.reference})
      : assert(map['batteryVoltage'] != null),
        assert(map['moisture'] != null),
        assert(map['timestamp'] != null),
        id = id,
        batteryVoltage = map['batteryVoltage'],
        moisture = map['moisture'],
        timestamp = map['timestamp'];

  Observation.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.documentID, snapshot.data,
            reference: snapshot.reference);

  @override
  String toString() => "Observation<$id>";
}

class SensorDetailsPage extends StatefulWidget {
  final Sensor sensor;

  SensorDetailsPage({Key key, @required this.sensor}) : super(key: key);

  @override
  _SensorDetailsPageState createState() {
    return _SensorDetailsPageState();
  }
}

class _SensorDetailsPageState extends State<SensorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.sensor.reference.collection("observations").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Sensor ' + widget.sensor.id),
          ),
          body: new Container(
              padding: new EdgeInsets.all(32),
              child: charts.TimeSeriesChart(
                <charts.Series<DocumentSnapshot, DateTime>>[
                  new charts.Series<DocumentSnapshot, DateTime>(
                    id: 'Moisture',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (DocumentSnapshot obs, _) => obs["timestamp"].toDate(),
                    measureFn: (DocumentSnapshot obs, _) => obs["moisture"],
                    data: snapshot.data.documents,
                  ),
                ],
                animate: true,
              )),
        );
      },
    );
  }
}

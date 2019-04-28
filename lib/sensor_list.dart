import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'sensor.dart';
import 'insights.dart';

class SensorListPage extends StatefulWidget {
  @override
  _SensorListPageState createState() {
    return _SensorListPageState();
  }
}

class _SensorListPageState extends State<SensorListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('sensors').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Sensors'),
          ),
          body: new Container(
            padding: new EdgeInsets.all(32),
            child: _buildSensorWidgetList(context, snapshot.data.documents),
          ),
        );
      },
    );
  }

  Widget _buildSensorWidgetList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildSensorWidget(context, data)).toList(),
    );
  }

  Widget _buildSensorWidget(BuildContext context, DocumentSnapshot data) {
    final Sensor sensor = Sensor.fromSnapshot(data);

    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SensorDetailsPage(sensor: sensor)));
        },
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(sensor.id),
            subtitle: Text('(' +
                sensor.location.latitude.toString() +
                ', ' +
                sensor.location.longitude.toString() +
                ')'),
          ),
        ])));
  }
}

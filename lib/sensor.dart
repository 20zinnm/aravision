import 'package:cloud_firestore/cloud_firestore.dart';
class Sensor {
  final String id;
  final GeoPoint location;
  final String model;
  final DocumentReference reference;

  Sensor.fromMap(String id, Map<String, dynamic> map, {this.reference})
      : assert(map['location'] != null),
        assert(map['model'] != null),
        id = id,
        location = map['location'],
        model = map['model'];

  Sensor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.documentID, snapshot.data,
      reference: snapshot.reference);

  @override
  String toString() => "Sensor<$id>";
}

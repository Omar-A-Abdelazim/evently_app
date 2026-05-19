import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String uid;
  String id;
  String categoryId;
  String title;
  String description;
  DateTime date;
  DateTime time;

  Event(
    this.uid,
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.date,
    this.time,
  );

  factory Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Event(
      data?['id'] ?? '',
      data?['uid'] ?? '',
      data?['categoryId'] ?? '',
      data?['title'] ?? '',
      data?['description'] ?? '',
      (data?['date'] as Timestamp).toDate(),
      (data?['time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
    };
  }

  void operator [](int other) {}
}

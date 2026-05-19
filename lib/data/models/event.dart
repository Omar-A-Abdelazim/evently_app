import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String uid;
  String id;
  String categoryId;
  String title;
  String description;
  DateTime date;
  DateTime time;

  List<String> favorites = [];

  Event(
    this.uid,
    this.id,
    this.categoryId,
    this.title,
    this.description,
    this.date,
    this.time,
    this.favorites,
  );

  factory Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Event(
      data?['uid'] ?? '',
      data?['id'] ?? '',
      data?['categoryId'] ?? '',
      data?['title'] ?? '',
      data?['description'] ?? '',
      (data?['date'] as Timestamp).toDate(),
      (data?['time'] as Timestamp).toDate(),
      ((data?['favorites'] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
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
      'favorites': favorites,
    };
  }

  void operator [](int other) {}
}

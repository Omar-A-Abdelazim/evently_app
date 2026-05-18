import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/data/models/event.dart';

class FirebaseEventsDatabase {
  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Event> getCollectionReference() {
    return db
        .collection('events')
        .withConverter(
          fromFirestore: Event.fromFirestore,
          toFirestore: (Event event, options) => event.toFirestore(),
        );
  }

  Future<void> createEvent(Event event) async {
    var refrence = getCollectionReference();
    var doc = refrence.doc();
    event.id = doc.id;
    await doc.set(event);
  }
}

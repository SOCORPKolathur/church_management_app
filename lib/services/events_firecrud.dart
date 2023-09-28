import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/event_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference EventCollection = firestore.collection('Events');
final FirebaseStorage fs = FirebaseStorage.instance;

class EventsFireCrud {
  static Stream<List<EventsModel>> fetchEvents() =>
      EventCollection
          .orderBy("timestamp", descending: false)
          .snapshots().map((snapshot) => snapshot.docs
          .map((doc) => EventsModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<EventsModel>> fetchEventsWithFilter(DateTime start, DateTime end) =>
      EventCollection
          .where("timestamp", isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp", isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EventsModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

}

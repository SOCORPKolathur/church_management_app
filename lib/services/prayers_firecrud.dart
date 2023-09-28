import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prayers_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference PrayerCollection = firestore.collection('Prayers');

class PrayersFireCrud {

  static Stream<List<PrayersModel>> fetchPrayers() => PrayerCollection.orderBy("timestamp",descending: false)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          PrayersModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

}
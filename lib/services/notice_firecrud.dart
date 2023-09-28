import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference NoticeCollection = firestore.collection('Notices');

class NoticeFireCrud {

  static Stream<List<NoticeModel>> fetchNotice() => NoticeCollection.orderBy("timestamp",descending: false)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          NoticeModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

}
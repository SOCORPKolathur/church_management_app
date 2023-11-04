import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference BlogCollection = firestore.collection('Blogs');

class BlogFireCrud {
  static Stream<List<BlogModel>> fetchBlogs() => BlogCollection.orderBy(
          "timestamp", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BlogModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  static Stream<BlogModel> fetchBlogWithId(String id) =>
      BlogCollection.orderBy("timestamp", descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .where((element) => element['id'] == id)
              .map((doc) =>
                  BlogModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList().first);

  static Stream<List<BlogModel>> fetchBlogsWithFilter(
          DateTime start, DateTime end) =>
      BlogCollection.where("timestamp",
              isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp",
              isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  BlogModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
}

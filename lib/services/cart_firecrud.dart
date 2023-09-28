import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserCollection = firestore.collection('Users');

class CartFireCrud {

  static Stream<List<CartModel>> fetchCartsForUser(String userId) =>
      firestore.collection('Users').orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['id'] == userId)
          .map((doc) => CartModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

}

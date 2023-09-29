import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference ProductsCollection = firestore.collection('Products');

class ProductsFireCrud {

  static Stream<List<ProductModel>> fetchProducts() =>
      FirebaseFirestore.instance.collection('Products')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

}

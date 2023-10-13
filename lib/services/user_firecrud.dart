import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/cart_model.dart';
import '../models/orders_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserCollection = firestore.collection('Users');
final CollectionReference OrdersCollection = firestore.collection('Orders');
final FirebaseStorage fs = FirebaseStorage.instance;

class UserFireCrud {

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Stream<List<UserModel>> fetchUsers() =>
      UserCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<UserModel> fetchUsersWithId(String id) =>
      UserCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['id'] == id)
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList().first);

  static Stream<UserModel> checkUsersWithPhone(String phone) =>
      UserCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['phone'] == phone)
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList().first);


  static Stream<List<UserModel>> fetchUsersWithFilter(String profession) =>
      UserCollection
          .where("profession", isEqualTo: profession.toUpperCase())
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<UserModel>> fetchUsersWithSearchText(String text) =>
      UserCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['firstName'].toString().toLowerCase().startsWith(text) || element['profession'].toString().toLowerCase().startsWith(text) || element['phone'].toString().toLowerCase().startsWith(text))
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<OrdersModel>> fetchOrdersForUser(String userId) =>
      firestore.collection('Users')
          .doc(userId).collection("Orders")
          .orderBy("timestamp",descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => OrdersModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<CartModel>> fetchCartsForUser(String userId) =>
      UserCollection.doc(userId).collection("Carts").snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => CartModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addToCart(
      {
        required String userDocId,
        required double price,
        required String imgUrl,
        required int quantity,
        required String productId,
        required String productName,
      }) async {
    Response response = Response();
    DocumentReference documentReferencer = UserCollection.doc(userDocId).collection('Carts').doc(productId);
    CartModel cart = CartModel(
        id: "",
      time: DateFormat.jm().format(DateTime.now()),
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      price: price,
      imgUrl: imgUrl,
      quantity: quantity,
      productId: productId,
      productName: productName,
    );
    cart.id = productId;
    var json = cart.toJson();
    print(json);
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> addToOrder(
      {
        required String userDocId,
        required String phone,
        required String method,
        required String status,
        required String userName,
        required double amount,
        required List<Products> products,
        required String address,
      }) async {
    Response response = Response();
    DocumentReference documentReferencer = UserCollection.doc(userDocId).collection('Orders').doc();
    DocumentReference documentReferencer1 = OrdersCollection.doc();
    OrdersModel order = OrdersModel(
      id: "",
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      time: DateFormat('hh:mm a').format(DateTime.now()),
      phone: phone,
      method: method,
      status: status,
      userName: userName,
      amount: amount,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      products: products,
      address: address,
      orderId: "",
    );
    order.id = documentReferencer.id;
    order.orderId = generateRandomString(8);
    var json = order.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    var result1 = await documentReferencer1.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> deleteCart({required String userDocId,required String docId}) async {
    Response res = Response();
    DocumentReference documentReferencer = UserCollection.doc(userDocId).collection('Carts').doc(docId);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> updateCartQuantity({required String userDocId,required String docId,required int quantity}) async {
    Response res = Response();
    DocumentReference documentReferencer = UserCollection.doc(userDocId).collection('Carts').doc(docId);
    var result = await documentReferencer.update({
      "quantity" : quantity
    });
    return res;
  }

  static Future<Response> addUser(
      {required File image,
        required String baptizeDate,
        required String anniversaryDate,
        required String maritialStatus,
        required String bloodGroup,
        required String dob,
        required String email,
        required String firstName,
        required String lastName,
        required String locality,
        required String phone,
        required String profession,
        required String password,
        required String about,
        required String address,
      }) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = UserCollection.doc();
    UserModel user = UserModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        profession: profession.toUpperCase(),
        phone: phone,
        locality: locality,
        lastName: lastName,
        firstName: firstName,
        maritialStatus: maritialStatus,
        email: email,
        dob: dob,
        about: about,
        address: address,
        password: password,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        anniversaryDate: anniversaryDate,
        imgUrl: downloadUrl);
    user.id = documentReferencer.id;
    var json = user.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<Response> updateRecord(UserModel user,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      user.imgUrl = downloadUrl;
    }else{
      user.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = UserCollection.doc(user.id);
    var result = await documentReferencer.update(user.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = UserCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }


}

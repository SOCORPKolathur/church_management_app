import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';
import '../models/user_register_model.dart';
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserRegisterCollection =
    firestore.collection('NewlyRegisteredUsers');
final FirebaseStorage fs = FirebaseStorage.instance;

class UserRegisterFireCrud {
  static Future<Response> addUserRegister({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String city,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = UserRegisterCollection.doc();
    UserRegisterModel register = UserRegisterModel(
      id: "",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      city: city,
      phone: phone,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    register.id = documentReferencer.id;
    var json = register.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }
}

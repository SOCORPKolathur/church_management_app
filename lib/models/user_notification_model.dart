import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

String UserNotificationModelToJson(UserNotificationModel data) => json.encode(data.toJson());

class UserNotificationModel {
  UserNotificationModel({

    this.token,

  });

  String? email;
  String? token;
  String? uid;

  static UserNotificationModel formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserNotificationModel(
      token: snapshot["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
  };
}

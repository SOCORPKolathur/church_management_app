import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneModel {
  String? id;
  String? zoneName;
  String? zoneId;
  String? leaderName;
  String? leaderPhone;
  num? timestamp;
  List<String>? areas;

  ZoneModel({this.zoneName, this.zoneId, this.leaderName, this.leaderPhone, this.areas, this.id, this.timestamp});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    leaderName = json['leaderName'];
    leaderPhone = json['leaderPhone'];
    timestamp = json['timestamp'];
    areas = json['areas'].cast<String>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zoneName'] = this.zoneName;
    data['zoneId'] = this.zoneId;
    data['leaderName'] = this.leaderName;
    data['leaderPhone'] = this.leaderPhone;
    data['timestamp'] = this.timestamp;
    data['areas'] = this.areas;
    return data;
  }
}

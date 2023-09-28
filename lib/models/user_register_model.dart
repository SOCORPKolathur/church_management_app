class UserRegisterModel {
  String? id;
  int? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? city;

  UserRegisterModel(
      {this.id,
        this.timestamp,
        this.firstName,
        this.lastName,
        this.phone,
        this.email,
        this.city});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    email = json['email'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['city'] = this.city;
    return data;
  }
}

class CartModel {
  String? id;
  String? productId;
  String? imgUrl;
  double? price;
  String? date;
  String? time;
  String? productName;
  int? quantity;

  CartModel(
      {this.id,
        this.productId,
        this.price,
        this.imgUrl,
        this.date,
        this.time,
        this.productName,
        this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    price = json['price'];
    imgUrl = json['imgUrl'];
    date = json['date'];
    time = json['time'];
    productName = json['productName'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['imgUrl'] = this.imgUrl;
    data['price'] = this.price;
    data['date'] = this.date;
    data['time'] = this.time;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    return data;
  }
}

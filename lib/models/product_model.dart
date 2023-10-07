class ProductModel {
  String? id;
  num? timestamp;
  String? title;
  String? productId;
  String? imgUrl;
  String? description;
  String? categories;
  String? tags;
  String? sale;
  double? price;

  ProductModel(
      {this.id,
        this.timestamp,
        this.title,
        this.productId,
        this.imgUrl,
        this.description,
        this.categories,
        this.tags,
        this.sale,
        this.price});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    title = json['title'];
    productId = json['productId'];
    imgUrl = json['imgUrl'];
    description = json['description'];
    categories = json['categories'];
    tags = json['tags'];
    sale = json['sale'];
    price = double.parse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['title'] = this.title;
    data['productId'] = this.productId;
    data['imgUrl'] = this.imgUrl;
    data['description'] = this.description;
    data['categories'] = this.categories;
    data['tags'] = this.tags;
    data['sale'] = this.sale;
    data['price'] = this.price;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return title!;
      case 2:
        return _formatCurrency(price!);
      case 3:
        return categories!.toString();
      case 4:
        return tags!;
    }
    return '';
  }

  String _formatCurrency(double amount) {
    return 'Rs ${amount.toStringAsFixed(2)}';
  }
}

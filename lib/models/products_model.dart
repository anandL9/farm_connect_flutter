class ProductsModel {
  List<Products>? products;
  String? status;

  ProductsModel({this.products, this.status});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Products {
  String? mRP;
  String? sId;
  // String? image;
  String? notes;
  String? productCode;
  String? productName;
  String? sku;
  String? units;
  String? updatedate;
  String? value;
  bool? isCompleted = false;

  Products(
      {this.mRP,
      this.sId,
      // this.image,
      this.notes,
      this.productCode,
      this.productName,
      this.sku,
      this.units,
      this.updatedate,
      this.value,
      this.isCompleted});

  Products.fromJson(Map<String, dynamic> json) {
    mRP = json['MRP'];
    sId = json['_id'];
    // image = json['image'];
    notes = json['notes'];
    productCode = json['product_code'];
    productName = json['product_name'];
    sku = json['sku'];
    units = json['units'];
    updatedate = json['updatedate'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MRP'] = mRP;
    data['_id'] = sId;
    // data['image'] = image;
    data['notes'] = notes;
    data['product_code'] = productCode;
    data['product_name'] = productName;
    data['sku'] = sku;
    data['units'] = units;
    data['updatedate'] = updatedate;
    data['value'] = value;
    return data;
  }
}

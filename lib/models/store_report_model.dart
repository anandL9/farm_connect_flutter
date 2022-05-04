class StoreReportsModel {
  List<Reports>? reports;
  String? status;

  StoreReportsModel({this.reports, this.status});

  StoreReportsModel.fromJson(Map<String, dynamic> json) {
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(new Reports.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Reports {
  String? sId;
  String? comments;
  String? date;
  String? images;
  String? latitude;
  String? loginid;
  String? longitude;
  List<Products>? products;
  String? routeId;
  String? storeId;
  String? timestamp;

  Reports(
      {this.sId,
        this.comments,
        this.date,
        this.images,
        this.latitude,
        this.loginid,
        this.longitude,
        this.products,
        this.routeId,
        this.storeId,
        this.timestamp});

  Reports.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    comments = json['comments'];
    date = json['date'];
    images = json['images'];
    latitude = json['latitude'];
    loginid = json['loginid'];
    longitude = json['longitude'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    routeId = json['route_id'];
    storeId = json['store_id'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['comments'] = this.comments;
    data['date'] = this.date;
    data['images'] = this.images;
    data['latitude'] = this.latitude;
    data['loginid'] = this.loginid;
    data['longitude'] = this.longitude;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['route_id'] = this.routeId;
    data['store_id'] = this.storeId;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Products {
  String? closingStock;
  String? comments;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? productId;
  String? productName;
  String? stockOrder;
  String? stockReturns;

  Products(
      {this.closingStock,
        this.comments,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.productId,
        this.productName,
        this.stockOrder,
        this.stockReturns});

  Products.fromJson(Map<String, dynamic> json) {
    closingStock = json['closingStock'];
    comments = json['comments'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    productId = json['productId'];
    productName = json['productName'];
    stockOrder = json['stockOrder'];
    stockReturns = json['stockReturns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['closingStock'] = this.closingStock;
    data['comments'] = this.comments;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['stockOrder'] = this.stockOrder;
    data['stockReturns'] = this.stockReturns;
    return data;
  }
}
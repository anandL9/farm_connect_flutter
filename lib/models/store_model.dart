class StoresModel {
  List<Data>? data;
  String? status;

  StoresModel({this.data, this.status});

  StoresModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  bool? completed;
  String? storeId;
  String? storeName;

  Data({this.completed, this.storeId, this.storeName});

  Data.fromJson(Map<String, dynamic> json) {
    completed = json['completed'];
    storeId = json['store_id'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['completed'] = completed;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    return data;
  }
}
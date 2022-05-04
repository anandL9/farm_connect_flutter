class TestImage {
  List<Res>? res;
  String? status;

  TestImage({this.res, this.status});

  TestImage.fromJson(Map<String, dynamic> json) {
    if (json['res'] != null) {
      res = <Res>[];
      json['res'].forEach((v) {
        res!.add(new Res.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.res != null) {
      data['res'] = this.res!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Res {
  String? sId;
  Data? data;
  FilesId? filesId;
  int? n;

  Res({this.sId, this.data, this.filesId, this.n});

  Res.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    filesId = json['files_id'] != null
        ? new FilesId.fromJson(json['files_id'])
        : null;
    n = json['n'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.filesId != null) {
      data['files_id'] = this.filesId!.toJson();
    }
    data[''] = this.n;
    return data;
  }
}

class Data {
  Binary? binary;

  Data({this.binary});

  Data.fromJson(Map<String, dynamic> json) {
    binary =
    json['$binary'] != null ? new Binary.fromJson(json['$binary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.binary != null) {
      data['$binary'] = this.binary!.toJson();
    }
    return data;
  }
}

class Binary {
  String? base64;
  String? subType;

  Binary({this.base64, this.subType});

  Binary.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    subType = json['subType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64'] = this.base64;
    data['subType'] = this.subType;
    return data;
  }
}

class FilesId {
  String? oid;

  FilesId({this.oid});

  FilesId.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}
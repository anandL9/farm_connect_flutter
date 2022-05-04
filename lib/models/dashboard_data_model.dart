class DashboardDataModel {
  Data? data;
  String? status;

  DashboardDataModel({this.data, this.status});

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  LastWeek? lastWeek;
  List<Routes>? routes;
  LastWeek? thisWeek;
  LastWeek? today;
  LastWeek? yesterday;

  Data({this.lastWeek, this.routes, this.thisWeek, this.today, this.yesterday});

  Data.fromJson(Map<String, dynamic> json) {
    lastWeek = json['lastWeek'] != null
        ? LastWeek.fromJson(json['lastWeek'])
        : null;
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(Routes.fromJson(v));
      });
    }
    thisWeek = json['thisWeek'] != null
        ? LastWeek.fromJson(json['thisWeek'])
        : null;
    today = json['today'] != null ? LastWeek.fromJson(json['today']) : null;
    yesterday = json['yesterday'] != null
        ? LastWeek.fromJson(json['yesterday'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lastWeek != null) {
      data['lastWeek'] = lastWeek!.toJson();
    }
    if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    if (thisWeek != null) {
      data['thisWeek'] = thisWeek!.toJson();
    }
    if (today != null) {
      data['today'] = today!.toJson();
    }
    if (yesterday != null) {
      data['yesterday'] = yesterday!.toJson();
    }
    return data;
  }
}

class LastWeek {
  int? totalStore;
  int? visitedStore;

  LastWeek({this.totalStore, this.visitedStore});

  LastWeek.fromJson(Map<String, dynamic> json) {
    totalStore = json['total_store'];
    visitedStore = json['visited_store'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_store'] = totalStore;
    data['visited_store'] = visitedStore;
    return data;
  }
}

class Routes {
  String? routeId;
  String? routeName;

  Routes({this.routeId, this.routeName});

  Routes.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    routeName = json['route_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route_id'] = routeId;
    data['route_name'] = routeName;
    return data;
  }
}
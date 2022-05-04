class LoginModel {
  String? status;
  User? user;

  LoginModel({this.status, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? aadhaarNumber;
  String? address;
  String? date;
  String? designation;
  String? email;
  String? firstName;
  String? lastName;
  String? manager;
  String? panNumber;
  String? password;
  String? primaryNumber;
  String? secondaryNumber;
  String? userName;

  User(
      {this.aadhaarNumber,
      this.address,
      this.date,
      this.designation,
      this.email,
      this.firstName,
      this.lastName,
      this.manager,
      this.panNumber,
      this.password,
      this.primaryNumber,
      this.secondaryNumber,
      this.userName});

  User.fromJson(Map<String, dynamic> json) {
    aadhaarNumber = json['aadhaar_number'];
    address = json['address'];
    date = json['date'];
    designation = json['designation'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    manager = json['manager'];
    panNumber = json['pan_number'];
    password = json['password'];
    primaryNumber = json['phone_number'];
    secondaryNumber = json['secondary_number'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aadhaar_number'] = aadhaarNumber;
    data['address'] = address;
    data['date'] = date;
    data['designation'] = designation;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['manager'] = manager;
    data['pan_number'] = panNumber;
    data['password'] = password;
    data['phone_number'] = primaryNumber;
    data['secondary_number'] = secondaryNumber;
    data['user_name'] = userName;
    return data;
  }
}

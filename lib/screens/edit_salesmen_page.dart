import 'dart:convert';

import 'package:farm_connect_salesmen/models/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/api_end_points.dart';
import '../constants/color_constants.dart';
import '../utils/pref_utils.dart';
import 'package:http/http.dart' as http;

import '../utils/utility_function.dart';

class EditSalesmenPage extends StatefulWidget {
  const EditSalesmenPage({Key? key}) : super(key: key);

  @override
  _EditSalesmenPageState createState() => _EditSalesmenPageState();
}

class _EditSalesmenPageState extends State<EditSalesmenPage> {
  TextEditingController textEditingControllerFirstName =
      TextEditingController();
  TextEditingController textEditingControllerLastName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerAddress = TextEditingController();
  bool isApiCalled = false;
  final _formKey = GlobalKey<FormState>();
  LoginModel loginModel = LoginModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isApiCalled
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : TextButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          callEditUserApi();
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Palette.textButtonColor,
                        size: 18,
                      ),
                      label: const Text(
                        'Save',
                        style: TextStyle(color: Palette.textButtonColor),
                      )),
            )
          ],
        ),
        body: FutureBuilder<String?>(
            future: getUserData(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                loginModel = LoginModel.fromJson(jsonDecode(snapShot.data!));
                textEditingControllerFirstName.text =
                    loginModel.user!.firstName!;
                textEditingControllerLastName.text = loginModel.user!.lastName!;
                textEditingControllerEmail.text = loginModel.user!.email!;
                textEditingControllerAddress.text = loginModel.user!.address!;
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey,
                            ),
                            child: Center(
                              child: Text(
                                loginModel.user!.firstName![0].toUpperCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: loginModel.user?.userName,
                            enabled: false,
                            decoration: InputDecoration(
                              label: const Text('User Name'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                            controller: textEditingControllerFirstName,
                            decoration: InputDecoration(
                              label: const Text('First Name'),
                              hintText: 'Enter First Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                            controller: textEditingControllerLastName,
                            decoration: InputDecoration(
                              label: const Text('Last Name '),
                              hintText: 'Enter Last Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: textEditingControllerEmail,
                            decoration: InputDecoration(
                              label: const Text('Email'),
                              hintText: 'Enter Email Address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Address is required';
                              }
                              return null;
                            },
                            controller: textEditingControllerAddress,
                            decoration: InputDecoration(
                              label: const Text('Address'),
                              hintText: 'Enter Address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: loginModel.user?.designation,
                            enabled: false,
                            decoration: InputDecoration(
                              label: const Text('Designation'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: loginModel.user?.manager,
                            enabled: false,
                            decoration: InputDecoration(
                              label: const Text('Manager'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: loginModel.user?.primaryNumber,
                            enabled: false,
                            decoration: InputDecoration(
                              label: const Text('Mobile number'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: loginModel.user?.secondaryNumber,
                            enabled: false,
                            decoration: InputDecoration(
                              label: const Text('Secondary Number'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  void callEditUserApi() async {
    setState(() {
      isApiCalled = true;
    });
    var url = Uri.parse(ApiEndPoints.editUserUrl);
    var body = jsonEncode({
      "phone_number": loginModel.user?.primaryNumber,
      "user_name": loginModel.user?.userName,
      "first_name": textEditingControllerFirstName.text.trim(),
      "last_name": textEditingControllerLastName.text.trim(),
      "email": textEditingControllerEmail.text.trim(),
      "address": textEditingControllerAddress.text.trim()
    });

    debugPrint('api $url and $body');
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var loginUserData = LoginModel.fromJson(jsonDecode(response.body));
    debugPrint('response body ${response.body}');
    if (response.statusCode == 200) {
      setUserData(jsonDecode(response.body));
      setState(() {
        isApiCalled = false;
      });
      showAlertDialogNew(
          context: context,
          message: 'Data updated successfully',
          onTap: () {
            Navigator.pop(context);
          });
    } else {
      showSnackBar(context: context, message: 'something went wrong');
    }
  }
}

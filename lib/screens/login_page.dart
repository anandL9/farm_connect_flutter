import 'dart:convert';

import 'package:farm_connect_salesmen/constants/api_end_points.dart';
import 'package:farm_connect_salesmen/models/login_model.dart';
import 'package:farm_connect_salesmen/screens/home_page.dart';
import 'package:farm_connect_salesmen/utils/pref_utils.dart';
import 'package:farm_connect_salesmen/utils/utility_function.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isApiCalled = false, _showPassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerUserName =
      TextEditingController();
  final TextEditingController _textEditingControllerPassword =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/farm_connect_logo.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const Text(
                    'Farm Connect / Sales',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text('Good for you, good for globe.'),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _textEditingControllerUserName,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Enter Phone number',
                        label: Text('Phone number')),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10) {
                        return 'Enter a valid mobile number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: _textEditingControllerPassword,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      hintText: 'Enter Password',
                      label: const Text('Password'),
                    ),
                    validator: (value) {
                      if (value?.length == null || value!.isEmpty) {
                        return 'Password is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password? Login with OTP')),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: SizedBox(
                    width: 200,
                    child: isApiCalled
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                callLoginApi();
                              }
                            },
                            child: const Text('Login')),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void callLoginApi() async {
    setState(() {
      isApiCalled = true;
    });
    var url = Uri.parse(ApiEndPoints.loginUrl);
    debugPrint('url $url');
    String body = jsonEncode({
      "phone_number": _textEditingControllerUserName.text.trim(),
      "password": _textEditingControllerPassword.text.trim()
    });
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint('Data ${response.body}');
    var loginModel = LoginModel.fromJson(jsonDecode(response.body));
    setState(() {
      isApiCalled = false;
    });
    if (response.statusCode == 200) {
      setUserData(jsonDecode(response.body));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showSnackBar(context: context, message: loginModel.status!);
    }
  }
}

import 'dart:convert';

import 'package:farm_connect_salesmen/constants/api_end_points.dart';
import 'package:farm_connect_salesmen/models/login_model.dart';
import 'package:farm_connect_salesmen/screens/add_new_store_page.dart';
import 'package:farm_connect_salesmen/screens/edit_salesmen_page.dart';
import 'package:farm_connect_salesmen/screens/home_page.dart';
import 'package:farm_connect_salesmen/screens/login_page.dart';
import 'package:farm_connect_salesmen/utils/location_utility.dart';
import 'package:http/http.dart' as http;
import 'package:farm_connect_salesmen/utils/pref_utils.dart';
import 'package:farm_connect_salesmen/utils/utility_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/dashboard_data_model.dart';

class ProfileWidget extends StatefulWidget {
  final List<String>? routes;

  const ProfileWidget({Key? key, this.routes}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  LoginModel loginModel = LoginModel();
  bool isApiCalled = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getUserData(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            loginModel = LoginModel.fromJson(jsonDecode(snapShot.data!));
            return isApiCalled
                ? Wrap(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ],
                  )
                : Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              child: Image.asset(
                                'assets/farm_connect_logo.png',
                                height: 100,
                              ),
                            ),
                            Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueGrey),
                                  child: Text(
                                    loginModel.user!.firstName![0].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  '${loginModel.user!.firstName} ${loginModel.user!.lastName}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(loginModel.user!.primaryNumber!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                trailing: Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSalesmenPage()));
                                    },
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // const Divider(
                            //   thickness: 2,
                            //   height: 30,
                            // ),
                            ListTile(
                              horizontalTitleGap: 0,
                              dense: true,
                              onTap: () async {
                                bool checkInStatus = await getCheckInStatus();
                                showAlertDialog(
                                    context: context,
                                    message: checkInStatus
                                        ? 'Are you sure you want to check Out.'
                                        : 'Are you sure you want to check In.',
                                    onTap: () {
                                      Navigator.pop(context);
                                      callCheckInApi(checkInStatus);
                                    });
                              },
                              leading: const Icon(
                                Icons.door_front_door,
                                color: Colors.grey,
                                size: 20,
                              ),
                              title: FutureBuilder(
                                future: getCheckInStatus(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.data == true) {
                                    return const Text('Check out');
                                  } else {
                                    return const Text('Check In');
                                  }
                                },
                              ),

                              // dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onTap: () {},
                              title: const Text('Reset Password'),
                              dense: true,
                              horizontalTitleGap: 0,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddStorePage(
                                              routes: widget.routes,
                                            )));
                              },
                              leading: const Icon(
                                Icons.contact_page,
                                color: Colors.grey,
                                size: 20,
                              ),
                              title: const Text('Add a new Customer/Store'),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              onTap: () {},
                              leading: const Icon(
                                CupertinoIcons.doc_text_fill,
                                color: Colors.grey,
                                size: 20,
                              ),
                              title: const Text('Privacy Policy'),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              onTap: () async {
                                showAlertDialog(
                                    context: context,
                                    message: 'Are you sure,you want to log out',
                                    onTap: () {
                                      deleteAllSPData();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const LoginPage()),
                                          ModalRoute.withName('/loginPage'));
                                    });
                              },
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.grey,
                                size: 20,
                              ),
                              title: const Text('Log out'),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(
                              thickness: 2,
                              height: 30,
                            ),
                            Align(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel')))
                          ],
                        ),
                      ),
                    ],
                  );
          } else {
            const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Container();
        });
  }

  void callCheckInApi(bool checkInStatus) async {
    setState(() {
      isApiCalled = true;
    });
    Position position = await determinePosition();

    var url = Uri.parse(ApiEndPoints.checkinUrl);
    var body = jsonEncode({
      "loginid": loginModel.user!.primaryNumber,
      "username": loginModel.user!.userName,
      "latitude": '${position.latitude}',
      "longitude": '${position.longitude}',
      "timestamp": '${DateTime.now()}',
      "status": checkInStatus ? 'checkout' : 'checkin'
    });
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      isApiCalled = false;
    });
    if (response.statusCode == 200) {
      if (checkInStatus) {
        setCheckInStatus(false);
      } else {
        setCheckInStatus(true);
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          ModalRoute.withName('/homePage'));
    } else {
      showSnackBar(context: context, message: 'Something went wrong');
    }
  }
}

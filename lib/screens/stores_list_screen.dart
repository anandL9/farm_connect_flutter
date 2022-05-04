import 'dart:convert';

import 'package:custom_check_box/custom_check_box.dart';
import 'package:farm_connect_salesmen/models/store_model.dart';
import 'package:farm_connect_salesmen/screens/edit_sales_reports_page.dart';
import 'package:farm_connect_salesmen/screens/store_report_view_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../constants/api_end_points.dart';
import '../utils/pref_utils.dart';
import '../utils/utility_function.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'file_reports_page.dart';

class StoreListScreen extends StatefulWidget {
  final String routeId, routeName;

  const StoreListScreen({Key? key, required this.routeId, this.routeName = ''})
      : super(key: key);

  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  StoresModel _storeModel = StoresModel();
  bool isApiCalled = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    callStoresListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isApiCalled
        ? const CupertinoActivityIndicator()
        : Scrollbar(
            isAlwaysShown: false,
            thickness: 3,
            radius: const Radius.circular(5.0),
            child: _storeModel.data!.isEmpty
                ? const Center(
                    child: Text('No Stores attached to this route yet.'))
                : SmartRefresher(
                    onRefresh: () {
                      callStoresListApi();
                      _refreshController.refreshCompleted();
                    },
                    controller: _refreshController,
                    child: ListView.builder(
                        primary: true,
                        itemCount: _storeModel.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 10.0),
                            child: ListTile(
                              dense: true,
                              title: Text(_storeModel.data![index].storeName!),
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.grey, width: 0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              leading: CustomCheckBox(
                                value: _storeModel.data![index].completed!,
                                checkBoxSize: 20,
                                uncheckedFillColor: Colors.transparent,
                                borderColor: Colors.grey,
                                checkedFillColor: Colors.green,
                                uncheckedIconColor: Colors.grey,
                                borderRadius: 15,
                                onChanged: (val) {},
                              ),
                              onTap: () async {
                                if (await getCheckInStatus()) {
                                  if (_storeModel.data![index].completed!) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditSalesReport(
                                                  routeId: widget.routeId,
                                                  storeId: _storeModel
                                                      .data![index].storeId!,
                                                  routeName: widget.routeName,
                                                  storeName: _storeModel
                                                      .data![index].storeName!,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileReportsPage(
                                                  routeId: widget.routeId,
                                                  storeId: _storeModel
                                                      .data![index].storeId!,
                                                  routeName: widget.routeName,
                                                  storeName: _storeModel
                                                      .data![index].storeName!,
                                                )));
                                  }
                                } else {
                                  showSnackBar(
                                      context: context,
                                      message:
                                          'You are checked out, Please check in to continue');
                                }
                              },
                            ),
                          );
                        }),
                  ),
          );
  }

  void callStoresListApi() async {
    var url = Uri.parse(ApiEndPoints.storesDataUrl);
    String body = jsonEncode({
      "route_id": widget.routeId,
    });
    debugPrint('api $url and $body');
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isApiCalled = false;
        _storeModel = StoresModel.fromJson(jsonDecode(response.body));
      });
    } else {
      showSnackBar(context: context, message: 'Unable to fetch stores');
    }
  }
}

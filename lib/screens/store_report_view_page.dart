import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:farm_connect_salesmen/models/store_report_model.dart';
import 'package:farm_connect_salesmen/models/test_model.dart';
import 'package:farm_connect_salesmen/utils/image_utils.dart';
import 'package:farm_connect_salesmen/widgets/show_image_widget.dart';
import 'package:flutter/material.dart';

import '../constants/api_end_points.dart';
import 'package:http/http.dart' as http;

import '../models/login_model.dart';
import '../utils/pref_utils.dart';
import '../utils/utility_function.dart';
import '../widgets/_dark_container_widget.dart';

class StoreReportViewPage extends StatefulWidget {
  final String routeId, storeId, routeName, storeName;

  const StoreReportViewPage(
      {Key? key,
      this.routeId = '',
      this.storeId = '',
      this.routeName = '',
      this.storeName = ''})
      : super(key: key);

  @override
  _StoreReportViewPageState createState() => _StoreReportViewPageState();
}

class _StoreReportViewPageState extends State<StoreReportViewPage> {
  bool isApiCalled = true;
  StoreReportsModel storeReportsModel = StoreReportsModel();

  @override
  void initState() {
    // callApiData();
    callSalesReportApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Data'),
      ),
      body: isApiCalled
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DarkContainerWidget(
                        title: widget.storeName,
                        subtitle: 'Store',
                      ),
                      DarkContainerWidget(
                        title: widget.routeName,
                        subtitle: 'Route',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Date: ${storeReportsModel.reports![0].date}'),
                  SizedBox(
                    height: 10,
                  ),
                  const Text('Products:'),
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            storeReportsModel.reports![0].products?.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 2,
                                child: ExpansionTile(
                                  title: Text(storeReportsModel.reports![0]
                                      .products![index].productName!),
                                  children: [
                                    ListTile(
                                      title: Text(storeReportsModel.reports![0]
                                          .products![index].closingStock!),
                                      subtitle: const Text('Closing Stock:'),
                                    ),
                                    ListTile(
                                      title: Text(storeReportsModel.reports![0]
                                          .products![index].stockOrder!),
                                      subtitle: const Text('Orders:'),
                                    ),
                                    ListTile(
                                      title: Text(storeReportsModel.reports![0]
                                          .products![index].stockReturns!),
                                      subtitle: const Text('Returns:'),
                                    ),
                                    ListTile(
                                      title: Text(storeReportsModel
                                              .reports![0]
                                              .products![index]
                                              .comments!
                                              .isNotEmpty
                                          ? storeReportsModel.reports![0]
                                              .products![index].comments!
                                          : 'None'),
                                      subtitle: const Text('Comments:'),
                                    ),
                                    const Text('Images:'),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ShowImageWidget(
                                              imageName: storeReportsModel
                                                  .reports![0]
                                                  .products![index]
                                                  .image1!,
                                            ),
                                            ShowImageWidget(
                                              imageName: storeReportsModel
                                                  .reports![0]
                                                  .products![index]
                                                  .image2!,
                                            ),
                                            ShowImageWidget(
                                              imageName: storeReportsModel
                                                  .reports![0]
                                                  .products![index]
                                                  .image3!,
                                            ),
                                            ShowImageWidget(
                                              imageName: storeReportsModel
                                                  .reports![0]
                                                  .products![index]
                                                  .image4!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),
    );
  }

  void callSalesReportApi() async {
    String? userData = await getUserData();
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(userData!));
    var url = Uri.parse(ApiEndPoints.storesReportsUrl);
    String body = jsonEncode({
      "loginid": loginModel.user!.primaryNumber.toString(),
      "store_id": widget.storeId,
      "route_id": widget.routeId,
      "date": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString(),
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
      debugPrint('response body ${response.body}');
      setState(() {
        isApiCalled = false;
        storeReportsModel =
            StoreReportsModel.fromJson(jsonDecode(response.body));
      });
    } else {
      showSnackBar(context: context, message: 'Unable to fetch data');
    }
  }

  // callApiData() async {
  //   print('object ,${Uri.parse('http://192.168.1.143:5000/mobileapi/image')}');
  //   var response = await http.get(
  //     Uri.parse('http://192.168.1.143:5000/mobileapi/image'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   TestImage testImage = TestImage.fromJson(jsonDecode(response.body));
  //   print('object data ${ testImage.res![0].data?.binary?.base64}');
  //   setState(() {
  //     isApiCalled = false;
  //     imagename = testImage.res![0].data!.binary!.base64!;
  //   });
  // }
  //
  // Widget getImageBase64() {
  //   var _imageBase64 = imagename;
  //   const Base64Codec base64 = Base64Codec();
  //   var bytes = base64.decode(_imageBase64);
  //   return Image.memory(
  //     bytes,
  //     width: 200,
  //     height: 200,
  //     fit: BoxFit.fitWidth,
  //   );
  // }
}

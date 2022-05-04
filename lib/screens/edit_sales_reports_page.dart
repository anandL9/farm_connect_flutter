import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/api_end_points.dart';
import '../constants/color_constants.dart';
import '../database/database_helper.dart';
import '../models/login_model.dart';
import '../models/products_model.dart';
import '../models/store_report_model.dart';
import '../utils/image_utils.dart';
import '../utils/location_utility.dart';
import '../utils/pref_utils.dart';
import 'package:http/http.dart' as http;

import '../utils/utility_function.dart';
import '../widgets/_dark_container_widget.dart';
import '../widgets/image_container.dart';
import 'home_page.dart';

class EditSalesReport extends StatefulWidget {
  final String routeId, storeId, routeName, storeName;

  const EditSalesReport(
      {Key? key,
      required this.routeId,
      required this.storeId,
      required this.routeName,
      required this.storeName})
      : super(key: key);

  @override
  _EditSalesReportState createState() => _EditSalesReportState();
}

class _EditSalesReportState extends State<EditSalesReport> {
  bool isApiCalled = true, isCommentsEnabled = false;
  final dbHelper = DatabaseHelper.instance;
  int selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath = '', _imagePath2 = '', _imagePath3 = '', _imagePath4 = '';
  ProductsModel productsModel = ProductsModel();

  TextEditingController textEditingControllerA = TextEditingController();
  TextEditingController textEditingControllerB = TextEditingController();
  TextEditingController textEditingControllerC = TextEditingController();
  TextEditingController textEditingControllerComments = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper.delete();
    callAllProductsApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Sales Data'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isApiCalled
                  ? const CupertinoActivityIndicator()
                  : TextButton.icon(
                      onPressed: () {
                        showAlertDialog(
                            context: context,
                            message: 'Are you sure you want to submit data?',
                            onTap: () {
                              Navigator.pop(context);
                              callPostDataApi();
                            });
                      },
                      icon: const Icon(
                        Icons.ios_share,
                        color: Palette.textButtonColor,
                        size: 18,
                      ),
                      label: const Text(
                        'Submit',
                        style: TextStyle(color: Palette.textButtonColor),
                      )),
            )
          ],
        ),
        body: isApiCalled
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(
                          height: 30,
                        ),
                        Text('Products'),
                        SizedBox(
                          height: 230,
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            childAspectRatio: 0.35,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                productsModel.products!.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  _getData(productsModel
                                      .products![index].productCode!);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color: selectedIndex == index
                                            ? Colors.green
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        bottom: 2.0,
                                        top: 2.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                  child: Row(
                                                children: [
                                                  Checkbox(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    value:
                                                        selectedIndex == index,
                                                    onChanged: (value) {},
                                                    activeColor: Colors.green,
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                    productsModel
                                                        .products![index]
                                                        .productName!,
                                                    maxLines: 2,
                                                  )),
                                                ],
                                              )),
                                              // Text(
                                              //   productsModel.products![index]
                                              //           .isCompleted!
                                              //       ? 'Completed'
                                              //       : 'Pending',
                                              //   style: const TextStyle(
                                              //       fontSize: 10.0),
                                              // )
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/farm_connect_logo.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border: TableBorder.all(
                                borderRadius: BorderRadius.circular(5),
                                width: 1.5,
                                color: Colors.blue),
                            showBottomBorder: true,
                            columns: <DataColumn>[
                              const DataColumn(
                                label: Text(
                                  'Product',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  productsModel
                                      .products![selectedIndex].productName!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                            rows: [
                              DataRow(cells: [
                                const DataCell(
                                  Text(
                                    'Closing Stock',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                DataCell(
                                    TextFormField(
                                      onChanged: (String value) {
                                        _insertIntoDb();
                                        if (textEditingControllerA.text != '' &&
                                            textEditingControllerB.text != '' &&
                                            textEditingControllerC.text != '') {
                                          setProductStatus(true);
                                        } else {
                                          setProductStatus(false);
                                        }
                                      },
                                      controller: textEditingControllerA,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Data',
                                      ),
                                    ),
                                    showEditIcon: true),
                              ]),
                              DataRow(cells: [
                                const DataCell(
                                  Text(
                                    'Order',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                DataCell(
                                    TextFormField(
                                      onChanged: (String value) {
                                        _insertIntoDb();
                                        if (textEditingControllerA.text != '' &&
                                            textEditingControllerB.text != '' &&
                                            textEditingControllerC.text != '') {
                                          setProductStatus(true);
                                        } else {
                                          setProductStatus(false);
                                        }
                                      },
                                      controller: textEditingControllerB,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Data'),
                                    ),
                                    showEditIcon: true),
                              ]),
                              DataRow(cells: [
                                const DataCell(
                                  Text(
                                    'Returns',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                DataCell(
                                    TextFormField(
                                      onChanged: (String value) {
                                        if (value.isEmpty ||
                                            int.parse(value) == 0) {
                                          isCommentsEnabled = false;
                                        } else {
                                          isCommentsEnabled = true;
                                        }
                                        _insertIntoDb();
                                        if (textEditingControllerA.text != '' &&
                                            textEditingControllerB.text != '' &&
                                            textEditingControllerC.text != '') {
                                          setProductStatus(true);
                                        } else {
                                          setProductStatus(false);
                                        }
                                      },
                                      controller: textEditingControllerC,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Data',
                                      ),
                                    ),
                                    showEditIcon: true),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          enabled: isCommentsEnabled,
                          onChanged: (String value) {
                            _insertIntoDb();
                          },
                          controller: textEditingControllerComments,
                          maxLines: 2,
                          decoration: InputDecoration(
                              hintText: 'Enter Comments',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Attach images :'),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ImageContainer(
                                  imagePath: _imagePath!,
                                  onCancelTap: () {
                                    setState(() {
                                      _imagePath = '';
                                    });
                                  },
                                  onViewTap: () {
                                    enlargeImage(
                                        imageName: _imagePath!,
                                        context: context);
                                  },
                                  onAddTap: () {
                                    showImageDialog(0);
                                  }),
                              ImageContainer(
                                  imagePath: _imagePath2!,
                                  onCancelTap: () {
                                    setState(() {
                                      _imagePath2 = '';
                                    });
                                  },
                                  onViewTap: () {
                                    enlargeImage(
                                        imageName: _imagePath2!,
                                        context: context);
                                  },
                                  onAddTap: () {
                                    showImageDialog(1);
                                  }),
                              ImageContainer(
                                  imagePath: _imagePath3!,
                                  onCancelTap: () {
                                    setState(() {
                                      _imagePath3 = '';
                                    });
                                  },
                                  onViewTap: () {
                                    enlargeImage(
                                        imageName: _imagePath3!,
                                        context: context);
                                  },
                                  onAddTap: () {
                                    showImageDialog(2);
                                  }),
                              ImageContainer(
                                  imagePath: _imagePath4!,
                                  onCancelTap: () {
                                    setState(() {
                                      _imagePath4 = '';
                                    });
                                  },
                                  onViewTap: () {
                                    enlargeImage(
                                      imageName: _imagePath4!,
                                      context: context,
                                    );
                                  },
                                  onAddTap: () {
                                    showImageDialog(3);
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ]),
                ),
              ));
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
        var storeReportsModel =
            StoreReportsModel.fromJson(jsonDecode(response.body));
        _insertApiDataIntoDb(storeReportsModel);
      });
    } else {
      showSnackBar(context: context, message: 'Unable to fetch Data');
    }
  }

  void callAllProductsApi() async {
    var url = Uri.parse(ApiEndPoints.productsUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      callSalesReportApi();
      productsModel = ProductsModel.fromJson(json.decode(response.body));
      debugPrint('response body ${response.body}');
    }
  }

  Future<int> _checkIfDataExist(String productId) async {
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      if (element['productId'].toString().trim() == productId.trim()) {
        return element['_id'];
      }
    }
    return 0;
  }

  void _insertApiDataIntoDb(StoreReportsModel storeReportsModel) async {
    for (var product in storeReportsModel.reports![0].products!) {
      var row = {
        DatabaseHelper.columnProductId: product.productId,
        DatabaseHelper.columnProductName: product.productName,
        DatabaseHelper.columnClosingStock: product.closingStock,
        DatabaseHelper.columnOrder: product.stockOrder,
        DatabaseHelper.columnReturns: product.stockReturns,
        DatabaseHelper.columnComments: product.comments,
        DatabaseHelper.columnImage1: product.image1,
        DatabaseHelper.columnImage2: product.image2,
        DatabaseHelper.columnImage3: product.image3,
        DatabaseHelper.columnImage4: product.image4,
      };
      await dbHelper.insert(row);
      _getData(productsModel.products![selectedIndex].productCode!);
    }
  }

  // int getCompletedProduct() {
  //   int count = 0;
  //   for (var element in productsModel.products!) {
  //     if (element.isCompleted!) {
  //       count++;
  //     }
  //   }
  //   return count;
  // }

  void setProductStatus(bool value) {
    setState(() {
      productsModel.products![selectedIndex].isCompleted = value;
    });
  }

  void _insertIntoDb() async {
    if (await _checkIfDataExist(
            productsModel.products![selectedIndex].productCode!) ==
        0) {
      var row = {
        DatabaseHelper.columnProductId:
            productsModel.products![selectedIndex].productCode,
        DatabaseHelper.columnProductName:
            productsModel.products![selectedIndex].productName,
        DatabaseHelper.columnClosingStock:
            textEditingControllerA.text.isNotEmpty
                ? textEditingControllerA.text
                : '0',
        DatabaseHelper.columnOrder: textEditingControllerB.text.isNotEmpty
            ? textEditingControllerB.text
            : '0',
        DatabaseHelper.columnReturns: textEditingControllerC.text.isNotEmpty
            ? textEditingControllerC.text
            : '0',
        DatabaseHelper.columnComments: textEditingControllerComments.text,
        DatabaseHelper.columnImage1: _imagePath,
        DatabaseHelper.columnImage2: _imagePath2,
        DatabaseHelper.columnImage3: _imagePath3,
        DatabaseHelper.columnImage4: _imagePath4,
      };
      await dbHelper.insert(row);
    } else {
      var row = {
        DatabaseHelper.columnId: await _checkIfDataExist(
            productsModel.products![selectedIndex].productCode!),
        DatabaseHelper.columnProductId:
            productsModel.products![selectedIndex].productCode,
        DatabaseHelper.columnProductName:
            productsModel.products![selectedIndex].productName,
        DatabaseHelper.columnClosingStock:
            textEditingControllerA.text.isNotEmpty
                ? textEditingControllerA.text
                : '0',
        DatabaseHelper.columnOrder: textEditingControllerB.text.isNotEmpty
            ? textEditingControllerB.text
            : '0',
        DatabaseHelper.columnReturns: textEditingControllerC.text.isNotEmpty
            ? textEditingControllerC.text
            : '0',
        DatabaseHelper.columnComments: textEditingControllerComments.text,
        DatabaseHelper.columnImage1: _imagePath,
        DatabaseHelper.columnImage2: _imagePath2,
        DatabaseHelper.columnImage3: _imagePath3,
        DatabaseHelper.columnImage4: _imagePath4,
      };
      await dbHelper.update(row);
    }
  }

  void _getData(String productId) async {
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      if (element['productId'].toString().trim() == productId.trim()) {
        setState(() {
          textEditingControllerA.text = element['closingStock'].toString();
          textEditingControllerB.text = element['stockOrder'].toString();
          textEditingControllerC.text = element['stockReturns'].toString();
          textEditingControllerComments.text = element['comments'].toString();
          _imagePath = element['image1'].toString();
          _imagePath2 = element['image2'].toString();
          _imagePath3 = element['image3'].toString();
          _imagePath4 = element['image4'].toString();
        });
        if (int.parse(element['stockReturns']) != 0) {
          isCommentsEnabled = true;
        }else{
          isCommentsEnabled = false;
        }
        break;
      } else {
        setState(() {
          textEditingControllerA.text = '';
          textEditingControllerB.text = '';
          textEditingControllerC.text = '';
          textEditingControllerComments.text = '';
          _imagePath = '';
          _imagePath2 = '';
          _imagePath3 = '';
          _imagePath4 = '';
        });
      }
    }
  }

  void showImageDialog(int code) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final XFile? cameraImage =
                        await _picker.pickImage(source: ImageSource.camera);
                    _insertIntoDb();
                    setState(() {
                      cameraImage != null
                          ? code == 0
                              ? _imagePath = cameraImage.path
                              : code == 1
                                  ? _imagePath2 = cameraImage.path
                                  : code == 2
                                      ? _imagePath3 = cameraImage.path
                                      : _imagePath4 = cameraImage.path
                          : code == 0
                              ? _imagePath = ''
                              : code == 1
                                  ? _imagePath2 = ''
                                  : code == 2
                                      ? _imagePath3 = ''
                                      : _imagePath4 = '';
                    });
                  },
                  label: const Text('Camera'),
                  icon: const Icon(CupertinoIcons.camera),
                ),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final XFile? galleryImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    _insertIntoDb();
                    setState(() {
                      galleryImage != null
                          ? code == 0
                              ? _imagePath = galleryImage.path
                              : code == 1
                                  ? _imagePath2 = galleryImage.path
                                  : code == 2
                                      ? _imagePath3 = galleryImage.path
                                      : _imagePath4 = galleryImage.path
                          : code == 0
                              ? _imagePath = ''
                              : code == 1
                                  ? _imagePath2 = ''
                                  : code == 2
                                      ? _imagePath3 = ''
                                      : _imagePath4 = '';
                    });
                  },
                  label: const Text('Gallery'),
                  icon: const Icon(Icons.image_outlined),
                )
              ],
            ),
          );
        });
  }

  void callPostDataApi() async {
    setState(() {
      isApiCalled = true;
    });
    Position position = await determinePosition();
    List<Map<String, dynamic>> productsReportsList = [];
    final allRows = await dbHelper.queryAllRows();
    for (var element in allRows) {
      final newElement = Map.of(element);
      newElement.removeWhere((key, value) => key == '_id');
      productsReportsList.add(newElement);
    }
    String? userData = await getUserData();
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(userData!));
    var url = Uri.parse(ApiEndPoints.editReportsUrl);
    var body = jsonEncode({
      "loginid": loginModel.user!.primaryNumber.toString(),
      "date": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString(),
      "timestamp": DateTime.now().toString(),
      "store_id": widget.storeId,
      "route_id": widget.routeId,
      "products": productsReportsList,
      "comments": '',
      "images": '',
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString()
    });
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint('Response $url body $body ');
    setState(() {
      isApiCalled = false;
    });
    debugPrint('Response ${response.body} ');
    if (response.statusCode == 200) {
      showAlertDialogNew(
          context: context,
          message: 'Data added successfully',
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage()),
                ModalRoute.withName('/homePage'));
          });
      dbHelper.delete();
    } else {
      showSnackBar(context: context, message: 'Something went wrong');
    }
  }
}

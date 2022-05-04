import 'dart:convert';

import 'package:farm_connect_salesmen/constants/api_end_points.dart';
import 'package:farm_connect_salesmen/constants/constants.dart';
import 'package:farm_connect_salesmen/utils/image_utils.dart';
import 'package:farm_connect_salesmen/utils/location_utility.dart';
import 'package:farm_connect_salesmen/utils/utility_function.dart';
import 'package:farm_connect_salesmen/widgets/drop_down_widget.dart';
import 'package:farm_connect_salesmen/widgets/image_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../constants/color_constants.dart';
import '../models/login_model.dart';
import '../utils/pref_utils.dart';
import 'home_page.dart';

class AddStorePage extends StatefulWidget {
  final List<String>? routes;

  const AddStorePage({Key? key, this.routes}) : super(key: key);

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? _imagePath = '', _imagePath2 = '', _imagePath3 = '', _imagePath4 = '';
  String routeName = '', storeCategory = '';
  bool isApiCalled = false;
  TextEditingController textEditingControllerAddress = TextEditingController();
  TextEditingController textEditingControllerCustomerName =
      TextEditingController();
  TextEditingController textEditingControllerContactPerson =
      TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerTypeOfOutlet =
      TextEditingController();
  TextEditingController textEditingControllerGSTNumber =
      TextEditingController();
  TextEditingController textEditingControllerPrimaryNumber =
      TextEditingController();
  TextEditingController textEditingControllerSecondaryNumber =
      TextEditingController();
  TextEditingController textEditingControllerCity = TextEditingController();
  TextEditingController textEditingControllerState = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Customer'),
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
                        if (routeName.isEmpty) {
                          showSnackBar(
                              context: context,
                              message: 'Please select a route');
                        } else if (storeCategory.isEmpty) {
                          showSnackBar(
                              context: context,
                              message: 'Please select store category');
                        } else {
                          callAddCustomerApi();
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Palette.textButtonColor,
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(color: Palette.textButtonColor),
                    )),
          )
        ],
      ),
      body: isApiCalled
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerCustomerName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Customer/Store name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Customer Name *'),
                          hintText: 'Enter Customer/Store Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerContactPerson,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact person name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text('Contact Person *'),
                            hintText: 'Enter Contact Person Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'exapmle@gmail.com',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerGSTNumber,
                        decoration: InputDecoration(
                            label: const Text('GST Number'),
                            hintText: 'Enter your GSTIN ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Outlet type is required';
                          }
                          return null;
                        },
                        controller: textEditingControllerTypeOfOutlet,
                        decoration: InputDecoration(
                            label: const Text('Outlet type*'),
                            hintText: 'Enter type of outlet',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropDownWidget(
                        onValueChanges: (value) {
                          storeCategory = value;
                        },
                        dataList: Constants.storeCategory,
                        hintText: 'Select Store Category*',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropDownWidget(
                        onValueChanges: (value) {
                          routeName = value;
                        },
                        dataList: widget.routes!,
                        hintText: 'Select a route*',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textEditingControllerAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                  label: const Text('Address*'),
                                  hintText: 'Enter Full Address',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                String? address = await getAddressFromLatLong();
                                setState(() {
                                  textEditingControllerAddress.text = address!;
                                });
                              },
                              child: const Text(
                                'Get Current \nAddress.',
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerPrimaryNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Primary phone number is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            label: const Text('Primary Number *'),
                            hintText: 'Enter Primary Number',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerSecondaryNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            label: const Text('Secondary Number'),
                            hintText: 'Enter Secondary Number',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerCity,
                        decoration: InputDecoration(
                            label: const Text('City'),
                            hintText: 'Enter City',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: textEditingControllerState,
                        decoration: InputDecoration(
                            label: const Text('State'),
                            hintText: 'Enter State',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Attach images *'),
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
                                      imageName: _imagePath!, context: context);
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
                    ],
                  ),
                ),
              ),
            ),
    );
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

  void callAddCustomerApi() async {
    setState(() {
      isApiCalled = true;
    });
    String? userData = await getUserData();
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(userData!));
    var url = Uri.parse(ApiEndPoints.addCustomerUrl);
    var body = jsonEncode({
      "loginid": loginModel.user!.primaryNumber.toString(),
      "customer_name": textEditingControllerCustomerName.text,
      "contact_person": textEditingControllerContactPerson.text,
      "email": textEditingControllerEmail.text,
      "gst_number": textEditingControllerGSTNumber.text,
      "types_of_outlets": textEditingControllerTypeOfOutlet.text,
      "category": storeCategory,
      "date": DateTime.now().toString(),
      "location": "",
      "route": routeName,
      "address_line1": textEditingControllerAddress.text,
      "address_line2": "",
      "primary_number": textEditingControllerPrimaryNumber.text,
      "secondary_number": textEditingControllerSecondaryNumber.text,
      "city": textEditingControllerCity.text,
      "state": textEditingControllerState.text,
      "image1": _imagePath,
      "image2": _imagePath2,
      "image3": _imagePath3,
      "image4": _imagePath4
    });

    debugPrint('api $url and $body');
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint('response body ${response.body}');
    if (response.statusCode == 200) {
      showAlertDialogNew(
          context: context,
          message: 'Customer added successfully',
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage()),
                ModalRoute.withName('/homePage'));
          });
      setState(() {
        isApiCalled = false;
      });
    } else {
      showSnackBar(context: context, message: 'Something went wrong');
    }
  }
}

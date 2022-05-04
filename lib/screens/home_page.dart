import 'dart:convert';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_format/date_format.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:farm_connect_salesmen/constants/color_constants.dart';
import 'package:farm_connect_salesmen/models/dashboard_data_model.dart';
import 'package:farm_connect_salesmen/models/store.dart';
import 'package:farm_connect_salesmen/screens/stores_list_screen.dart';
import 'package:farm_connect_salesmen/utils/home_page_methods.dart';
import 'package:farm_connect_salesmen/utils/pref_utils.dart';
import 'package:farm_connect_salesmen/utils/utility_function.dart';
import 'package:farm_connect_salesmen/widgets/dashboard_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../constants/api_end_points.dart';
import '../models/login_model.dart';
import 'file_reports_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedValue = '0';
  List<Store> storedList = [];
  bool checkInStatus = false;
  bool isApiCalled = true, isRefreshed = false;
  DashboardDataModel dashboardDataModel = DashboardDataModel();

  @override
  void initState() {
    Geolocator.requestPermission();
    storedList = _storesList;
    callDashboardApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isApiCalled
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DoubleBackToCloseApp(
              snackBar:
                  const SnackBar(content: Text('Press back again to exit')),
              child: SwipeDetector(
                onSwipeDown: (offset) {
                  setState(() {
                    isRefreshed = true;
                  });
                  callDashboardApi();
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: SizedBox(
                              height: 280,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  elevation: 5,
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: DefaultTabController(
                                        length: 2,
                                        child: Scaffold(
                                          appBar: AppBar(
                                            elevation: 0,
                                            toolbarHeight: 40,
                                            actions: [
                                              TextButton.icon(
                                                  onPressed: () {
                                                    openProfileDialog(
                                                        context,
                                                        dashboardDataModel
                                                            .data?.routes);
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .profile_circled,
                                                    color:
                                                        Palette.textButtonColor,
                                                    size: 18,
                                                  ),
                                                  label: FutureBuilder(
                                                    future: getCheckInStatus(),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot<bool>
                                                                snapshot) {
                                                      if (snapshot.data ==
                                                          true) {
                                                        return const Text(
                                                          'Checked In',
                                                          style: TextStyle(
                                                            color: Palette
                                                                .textButtonColor,
                                                          ),
                                                        );
                                                      } else {
                                                        return const Text(
                                                          'Checked Out',
                                                          style: TextStyle(
                                                            color: Palette
                                                                .textButtonColor,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ))
                                            ],
                                            title:
                                                const Text('Sales Dashboard'),
                                            automaticallyImplyLeading: false,
                                            bottom: TabBar(
                                                isScrollable: true,
                                                indicator: MaterialIndicator(
                                                  color: Colors.orange,
                                                  paintingStyle:
                                                      PaintingStyle.fill,
                                                ),
                                                tabs: const [
                                                  Tab(
                                                    text: 'Today',
                                                  ),
                                                  Tab(
                                                    text: 'Yesterday',
                                                  ),
                                                ]),
                                          ),
                                          body: TabBarView(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formatDate(DateTime.now(), [
                                                      dd,
                                                      ' - ',
                                                      MM,
                                                      ' - ',
                                                      yyyy
                                                    ]),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Divider(
                                                    height: 20,
                                                    thickness: 2,
                                                  ),
                                                  Expanded(
                                                    child: ContainedTabBarView(
                                                      tabs: const [
                                                        Text('Today'),
                                                        Text('This Week'),
                                                      ],
                                                      tabBarProperties:
                                                          TabBarProperties(
                                                              width: 180,
                                                              height: 30,
                                                              background:
                                                                  Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              2.0)),
                                                                ),
                                                              ),
                                                              unselectedLabelColor:
                                                                  Colors.grey,
                                                              labelColor:
                                                                  Colors.blue,
                                                              position:
                                                                  TabBarPosition
                                                                      .bottom,
                                                              alignment:
                                                                  TabBarAlignment
                                                                      .end,
                                                              indicatorWeight:
                                                                  1,
                                                              indicatorSize:
                                                                  TabBarIndicatorSize
                                                                      .label),
                                                      views: [
                                                        DashboardData(
                                                          text: 'Today so far.',
                                                          completedStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.today
                                                                  ?.visitedStore,
                                                          totalStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.today
                                                                  ?.totalStore,
                                                        ),
                                                        DashboardData(
                                                          text: 'This Week',
                                                          completedStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.thisWeek
                                                                  ?.visitedStore,
                                                          totalStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.thisWeek
                                                                  ?.totalStore,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formatDate(
                                                        DateTime.now().subtract(
                                                            const Duration(
                                                                days: 1)),
                                                        [
                                                          dd,
                                                          ' - ',
                                                          MM,
                                                          ' - ',
                                                          yyyy
                                                        ]),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Divider(
                                                    height: 20,
                                                    thickness: 2,
                                                  ),
                                                  Expanded(
                                                    child: ContainedTabBarView(
                                                      tabs: const [
                                                        Text('Yesterday'),
                                                        Text('Last Week'),
                                                      ],
                                                      tabBarProperties:
                                                          TabBarProperties(
                                                              width: 180,
                                                              height: 30,
                                                              background:
                                                                  Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              2.0)),
                                                                ),
                                                              ),
                                                              unselectedLabelColor:
                                                                  Colors.grey,
                                                              labelColor:
                                                                  Colors.blue,
                                                              position:
                                                                  TabBarPosition
                                                                      .bottom,
                                                              alignment:
                                                                  TabBarAlignment
                                                                      .end,
                                                              indicatorWeight:
                                                                  1,
                                                              indicatorSize:
                                                                  TabBarIndicatorSize
                                                                      .label),
                                                      views: [
                                                        DashboardData(
                                                          text: 'Yesterday',
                                                          completedStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.yesterday
                                                                  ?.visitedStore,
                                                          totalStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.yesterday
                                                                  ?.totalStore,
                                                        ),
                                                        DashboardData(
                                                          text: 'Last Week',
                                                          completedStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.lastWeek
                                                                  ?.visitedStore,
                                                          totalStores:
                                                              dashboardDataModel
                                                                  .data
                                                                  ?.lastWeek
                                                                  ?.totalStore,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ))),
                            ),
                          ),
                          Visibility(
                              visible: isRefreshed,
                              child: Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(8),
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ))))),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: dashboardDataModel.data!.routes!.isEmpty
                              ? const Text(
                                  'You don"t have any routes assigned to you yet. Please contact your sales manager.')
                              : Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: DefaultTabController(
                                        length: dashboardDataModel
                                            .data!.routes!.length,
                                        child: Scaffold(
                                            appBar: AppBar(
                                              elevation: 0,
                                              automaticallyImplyLeading: false,
                                              toolbarHeight: 40,
                                              // actions: [
                                              //   IconButton(
                                              //       onPressed: () {
                                              //         showFilterBottomSheet();
                                              //       },
                                              //       icon: const Icon(
                                              //         Icons.filter_list_alt,
                                              //         size: 17,
                                              //       ))
                                              // ],
                                              bottom: PreferredSize(
                                                preferredSize:
                                                    const Size.fromHeight(10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TabBar(
                                                      isScrollable: true,
                                                      indicatorSize:
                                                          TabBarIndicatorSize
                                                              .label,
                                                      indicator:
                                                          MaterialIndicator(
                                                        color: Colors.orange,
                                                        paintingStyle:
                                                            PaintingStyle.fill,
                                                      ),
                                                      tabs: dashboardDataModel
                                                          .data!.routes!
                                                          .map((e) => Tab(
                                                                text:
                                                                    '${e.routeName}',
                                                                // child: const Text('data'),
                                                              ))
                                                          .toList()),
                                                ),
                                              ),
                                            ),
                                            body: TabBarView(
                                                children: dashboardDataModel
                                                    .data!.routes!
                                                    .map((e) {
                                              return StoreListScreen(
                                                routeId: e.routeId!,
                                                routeName: e.routeName!,
                                              );
                                            }).toList()))),
                                  ),
                                ),
                        ),
                      ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Store> _storesList = [
    Store('101', 'xyz store', false),
    Store('102', 'xyz store', false),
    Store('103', 'xyz store', false),
    Store('104', 'xyz store', true),
    Store('105', 'xyz store', false),
    Store('106', 'xyz store', false),
    Store('107', 'xyz store', false),
    Store('108', 'xyz store', true),
    Store('109', 'xyz store', false),
    Store('110', 'xyz store', false),
    Store('111', 'xyz store', false),
    Store('112', 'xyz store', false),
    Store('113', 'xyz store', true),
    Store('114', 'xyz store', false),
    Store('115', 'xyz store', false),
    Store('116', 'xyz store', false),
  ];

  void showFilterBottomSheet() {
    _storesList = storedList;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(40.0),
              child: Wrap(
                runSpacing: 15.0,
                alignment: WrapAlignment.center,
                children: [
                  const Text('Filter by:'),
                  CustomRadioButton(
                    elevation: 0,
                    shapeRadius: 50,
                    autoWidth: true,
                    selectedBorderColor: Colors.green,
                    unSelectedBorderColor: Colors.white,
                    unSelectedColor: Theme.of(context).canvasColor,
                    defaultSelected: _selectedValue,
                    buttonLables: const [
                      'All',
                      'Completed',
                      'Pending',
                    ],
                    buttonValues: const [
                      '0',
                      '1',
                      '2',
                    ],
                    buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.white,
                    ),
                    radioButtonValue: (value) {
                      Navigator.pop(context);
                      _selectedValue = value.toString();
                      setState(() {
                        if (value.toString() == '1') {
                          _storesList = _storesList
                              .where((element) => element.isCompleted)
                              .toList();
                        } else if (value.toString() == '2') {
                          _storesList = _storesList
                              .where((element) => !element.isCompleted)
                              .toList();
                        }
                      });
                    },
                    selectedColor: Colors.green,
                  ),
                ],
              ),
            ));
  }

  void callDashboardApi() async {
    String? userData = await getUserData();
    LoginModel loginModel = LoginModel.fromJson(jsonDecode(userData!));
    var url = Uri.parse(ApiEndPoints.dashboardDataUrl);
    String body = jsonEncode({
      "loginid": loginModel.user?.primaryNumber,
    });
    debugPrint('calle $url and $body');
    var response = await http.post(
      url,
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint('calle ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        isRefreshed = false;
        isApiCalled = false;
        dashboardDataModel =
            DashboardDataModel.fromJson(json.decode(response.body));
      });
    } else {
      showSnackBar(
          context: context,
          message: 'Something went wrong while fetching data');
    }
  }
}

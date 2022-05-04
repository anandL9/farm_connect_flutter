import 'package:farm_connect_salesmen/screens/home_page.dart';
import 'package:farm_connect_salesmen/utils/pref_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 10,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
              ),
              Expanded(
                  child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                width: 2,
                height: double.maxFinite,
              )),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(-5 / 360),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 30),
                    child: Column(
                      children: [
                        const Icon(  //make circular with first letter name
                          CupertinoIcons.profile_circled,
                          size: 70,
                        ),
                        const Text(
                          'James bond',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Looks Like you are checked out.Check in to continue with the app.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                onPressed: () async {
                                  setCheckInStatus(true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                },
                                child: const Text('Check In')))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

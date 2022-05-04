import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardData extends StatelessWidget {
  final String text;
  final int? completedStores, totalStores;

  const DashboardData(
      {Key? key,
      this.text = '',
      this.completedStores = 0,
      this.totalStores = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                child: RichText(
                  text: TextSpan(
                      text: '$completedStores',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                      children: [
                        TextSpan(
                          text: ' / $totalStores',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        )
                      ]),
                ),
              ),
            ],
          ),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: totalStores! > 0 ? completedStores! / totalStores! : 0,
            center: totalStores! > 0
                ? Text('${((completedStores! / totalStores!) * 100).toInt()}%')
                : const Text('_'),
          )
        ],
      ),
    );
  }
}

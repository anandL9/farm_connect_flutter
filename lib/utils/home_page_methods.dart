import 'package:farm_connect_salesmen/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

import '../models/dashboard_data_model.dart';

void openProfileDialog(BuildContext context, List<Routes>? routes) {
  List<String> routesList = [];
  routes?.forEach((element) {
    routesList.add(element.routeName!);
  });
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeOutQuad.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
                insetAnimationCurve: Curves.linear,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ProfileWidget(
                  routes: routesList,
                )),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

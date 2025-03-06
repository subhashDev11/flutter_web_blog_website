import 'dart:async';

import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget desktopView;
  final Widget? tabView;
  final Widget mobileView;

  const ResponsiveWidget({super.key, required this.desktopView, required this.mobileView, this.tabView});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          // Desktop View
          deviceTypeStreamController.add(AppDeviceType.desk);
          return desktopView;
        }else if (constraints.maxWidth > 600) {
          // Desktop View
          deviceTypeStreamController.add(AppDeviceType.mob);
          return  tabView ?? mobileView;
        } else {
          // Mobile View
          deviceTypeStreamController.add(AppDeviceType.mob);
          return mobileView;
        }
      },
    );
  }
}

StreamController<AppDeviceType> deviceTypeStreamController = StreamController<AppDeviceType>.broadcast();

enum AppDeviceType{
  mob,desk,
}
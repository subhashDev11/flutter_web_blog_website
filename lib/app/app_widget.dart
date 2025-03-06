import 'dart:ui';

import 'package:another_easyloading/another_easyloading.dart';
import 'package:autoformsai_blogs/core/app_router.dart';
import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late BlogCubit _blogState;

  @override
  void initState() {
    _blogState = context.read<BlogCubit>();
      _blogState.init();
    getIt<EasyLoadingService>().setEasyLoadingConfig(
      Theme.of(context).primaryColor,
      Theme.of(context).brightness == Brightness.dark,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "AutoFormsAI Articles",
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ThemeData.light().colorScheme.copyWith(
                surface: Colors.grey[100],
              ),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      builder: AnotherEasyLoading.init(),
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

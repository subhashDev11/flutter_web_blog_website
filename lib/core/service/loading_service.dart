import 'package:another_easyloading/another_easyloading.dart';
import 'package:flutter/material.dart';

class EasyLoadingService {
  void setEasyLoadingConfig(Color primaryColor, bool isDarkTheme) => AnotherEasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = LoadingIndicatorType.fadingCircle
    ..loadingStyle = isDarkTheme ? LoadingStyle.dark : LoadingStyle.light
    ..maskType = LoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = primaryColor
    ..indicatorColor = primaryColor
    ..userInteractions = true
    ..contentPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    )
    ..toastPosition = LoadingToastPosition.top;

  void show({bool? canDismiss}) {
    AnotherEasyLoading.show(
      dismissOnTap: canDismiss ?? true,
    );
  }

  void hide() {
    AnotherEasyLoading.dismiss();
  }

  bool get isActive => AnotherEasyLoading.isShow;

  Future<void> showToast({
    ToastType? toastType,
    String? title,
    required String content,
  }) async {
    AnotherEasyLoading.showStyledToast(
      content,
      toastPosition: LoadingToastPosition.top,
      type: toastType ?? ToastType.info,
    );
  }
}


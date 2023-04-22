import 'dart:developer';

import 'package:admin/common/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Loader {
  static void showProgressDialog(BuildContext context) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Lottie.asset(AppImage.loader),
            ),
          ),
        ),
      );
    } catch (ex) {
      log('ERRORRORO');
    }
  }

  static void hideProgressDialog() {
    try {
      Get.back();
    } catch (ex) {
      log('ERRORRORO');
    }
  }
}

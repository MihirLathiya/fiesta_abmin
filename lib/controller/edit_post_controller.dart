import 'dart:developer';

import 'package:admin/common/common_snackbar.dart';
import 'package:admin/common/image_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EditPostController extends GetxController {
  deleteBanner({String? id, String? name, BuildContext? context}) async {
    Get.back();
    showProgressDialog();

    try {
      await FirebaseFirestore.instance
          .collection('Banner')
          .doc(id)
          .delete()
          .then((value) async {
        final desertRef =
            await FirebaseStorage.instance.ref("Event/Banner/$name");
        await desertRef.delete();
        hideProgressDialog();
        CommonSnackBar.getSuccessSnackBar(
          context: context,
          title: 'Banner Delete Successfully',
        );
      });
    } catch (e) {
      hideProgressDialog();
      CommonSnackBar.getFailedSnackBar(
        context: context,
        title: '$e',
      );
    }
  }

  /// SHOW PROGRESS
  void showProgressDialog() {
    try {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(AppImage.loader),
            ),
          ),
        ),
      );
    } catch (ex) {
      log('hideProgressDialog--$ex');
    }
  }

  /// HIDE PROGRESS

  void hideProgressDialog() {
    try {
      Navigator.of(Get.overlayContext!).pop();
    } catch (ex) {
      log('hideProgressDialog--$ex');
    }
  }
}

showLoadingDialog() {
  try {} catch (ex) {
    log('hideProgressDialog--$ex');
  }
}

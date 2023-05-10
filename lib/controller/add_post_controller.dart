import 'dart:developer';
import 'dart:io';

import 'package:admin/common/common_snackbar.dart';
import 'package:admin/common/image_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddPostController extends GetxController {
  TextEditingController eventNameController = TextEditingController();
  DateTime? selectedDate;
  bool loader = false;
  bool isEvent = true;

  updateEvent() {
    isEvent = !isEvent;
    update();
  }

  updateLoader(bool value) {
    loader = value;
    update();
  }

  /// SINGLE IMAGE PICKER
  File? image;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result == null) {
      print("No file selected");
    } else {
      image = File(result.files.single.path!);
      update();

      print('Image pick= = ${result.files.single.name}');
    }
    update();
  }

  /// SINGLE BANNER PICKER
  File? bannerImage;

  bannerPickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result == null) {
      print("No file selected");
    } else {
      bannerImage = File(result.files.single.path!);
      update();

      print('Image pick= = ${result.files.single.name}');
    }
    update();
  }

  /// DATE PICKER
  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }

    update();
  }

  /// SHOW PROGRESS
  void showProgressDialog() {
    try {
      updateLoader(true);
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
      updateLoader(false);
      Navigator.of(Get.overlayContext!).pop();
    } catch (ex) {
      log('hideProgressDialog--$ex');
    }
  }

  /// UPLOAD IMAGE TO FIREBASE
  Future<String?> uploadFile(
      {File? file, String? filename, String? dir}) async {
    print("File path:$file");
    try {
      var response = await FirebaseStorage.instance
          .ref("Event/$dir/$filename")
          .putFile(file!);
      var result =
          await response.storage.ref("Event/$dir/$filename").getDownloadURL();
      return result;
    } catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  /// ADD TO FIREBASE
  addPostToFirebase(BuildContext context) async {
    showProgressDialog();
    if (image != null) {
      if (eventNameController.text.isNotEmpty) {
        if (selectedDate != null) {
          try {
            String? url = await uploadFile(
              file: image,
              filename: image.toString().split('/').last.toString(),
              dir: eventNameController.text.trim().toString(),
            );

            DocumentReference doc =
                FirebaseFirestore.instance.collection('Events').doc();
            await doc.set({
              'eventName': eventNameController.text.trim().toString(),
              'upcoming': isEvent,
              'eventDate': selectedDate,
              'thumbnail': url,
              'docId': doc.id,
            }).then((value) {
              hideProgressDialog();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Event Add Successfully'),
                ),
              );
              clearAll();
            });
          } catch (e) {
            hideProgressDialog();
          }
        } else {
          hideProgressDialog();

          /// SelectDate
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Select Date'),
            ),
          );
        }
      } else {
        hideProgressDialog();

        /// Event Name

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter Event name'),
          ),
        );
      }
    } else {
      hideProgressDialog();

      /// PickImage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select Image For Event'),
        ),
      );
    }
  }

  /// ADD BANNER
  addBannerToFirebase(BuildContext context) async {
    showProgressDialog();

    if (bannerImage != null) {
      try {
        String? bannerUrl = await uploadFile(
          file: bannerImage,
          filename: bannerImage.toString().split('/').last.toString(),
          dir: 'Banner',
        );

        DocumentReference doc =
            FirebaseFirestore.instance.collection('Banner').doc();
        await doc.set({
          'docId': doc.id,
          'bannerImage': bannerUrl,
          'bannerDate': DateTime.now(),
          'name': bannerImage.toString().split('/').last.toString(),
        }).then((value) {
          hideProgressDialog();

          CommonSnackBar.getSuccessSnackBar(
            context: context,
            title: 'Banner Add Successfully',
          );

          clearAll();
        });
      } catch (e) {
        hideProgressDialog();
        CommonSnackBar.getFailedSnackBar(
          context: context,
          title: '$e',
        );
      }
    } else {
      hideProgressDialog();

      /// PickImage
      CommonSnackBar.getWarningSnackBar(
          context: context, title: 'Select Banner For Event');
    }
  }

  /// CLEAR ALL
  clearAll() {
    selectedDate = null;
    eventNameController.clear();
    image = null;
    bannerImage = null;

    update();
  }
}

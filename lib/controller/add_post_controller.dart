import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostController extends GetxController {
  TextEditingController eventNameController = TextEditingController();
  DateTime? selectedDate;
  bool loader = false;
}

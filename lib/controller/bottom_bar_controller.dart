import 'package:admin/view/add_post_screen.dart';
import 'package:admin/view/edit_post_screen.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  int selectMenu = 0;
  List screen = [AddPostScreen(), EditPostScreen()];

  updateMenu(int index) {
    selectMenu = index;
    update();
  }
}

import 'package:admin/controller/add_post_controller.dart';
import 'package:admin/controller/bottom_bar_controller.dart';
import 'package:admin/controller/edit_post_controller.dart';
import 'package:get/get.dart';

class ControllerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(
      () => BottomBarController(),
      fenix: true,
    );
    Get.lazyPut<AddPostController>(
      () => AddPostController(),
      fenix: true,
    );
    Get.lazyPut<EditPostController>(
      () => EditPostController(),
      fenix: true,
    );
  }
}

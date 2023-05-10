import 'package:admin/common/app_const.dart';
import 'package:admin/common/button.dart';
import 'package:admin/common/color.dart';
import 'package:admin/common/image_path.dart';
import 'package:admin/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomBarScreen extends StatelessWidget {
  BottomBarScreen({Key? key}) : super(key: key);
  BottomBarController bottomBarController = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height / defaultHeight;
    double font = size * 0.97;
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: size * 45,
              right: size * 45,
              bottom: size * 10,
              top: size * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size * 60,
                  width: size * 100,
                  child: CommonButton(
                    radius: size * 15,
                    buttonColor: controller.selectMenu == 0
                        ? AppColor.mainColor
                        : AppColor.secondColor,
                    onPressed: () {
                      controller.updateMenu(0);
                    },
                    child: SvgPicture.asset(
                      AppImage.addPostIcon,
                      height: size * 26,
                      width: size * 26,
                    ),
                  ),
                ),
                SizedBox(
                  height: size * 60,
                  width: size * 100,
                  child: CommonButton(
                    radius: size * 15,
                    buttonColor: controller.selectMenu == 1
                        ? AppColor.mainColor
                        : AppColor.secondColor,
                    onPressed: () {
                      controller.updateMenu(1);
                    },
                    child: SvgPicture.asset(
                      AppImage.editPostIcon,
                      height: size * 26,
                      width: size * 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: controller.screen[controller.selectMenu],
        );
      },
    );
  }
}

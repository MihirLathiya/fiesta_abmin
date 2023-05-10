import 'package:admin/common/app_const.dart';
import 'package:admin/common/button.dart';
import 'package:admin/common/color.dart';
import 'package:admin/common/image_path.dart';
import 'package:admin/common/text.dart';
import 'package:admin/common/text_field.dart';
import 'package:admin/controller/add_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with SingleTickerProviderStateMixin {
  AddPostController addPostController = Get.put(AddPostController());
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height / defaultHeight;
    double font = size * 0.97;
    return GetBuilder<AddPostController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.transparent,
            bottom: PreferredSize(
              preferredSize: Size(Get.width, 10 * size),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 * size),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 20 * size,
                  labelColor: AppColor.black,
                  labelPadding: EdgeInsets.only(top: 20 * size),
                  indicator: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(20 * size),
                  ),
                  controller: tabController,
                  tabs: [
                    CommonText(
                      text: 'Event',
                      fontSize: 14 * font,
                    ),
                    CommonText(
                      text: 'Banner',
                      fontSize: 14 * font,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Post(controller: controller, font: font, size: size),
              Banner(controller: controller, font: font, size: size),
            ],
          ),
        );
      },
    );
  }
}

/// FOR POST
class Post extends StatelessWidget {
  final AddPostController controller;
  final double size;
  final double font;
  const Post(
      {Key? key,
      required this.controller,
      required this.size,
      required this.font})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 * size),
        child: Column(
          children: [
            SizedBox(
              height: 20 * size,
            ),
            if (controller.image == null)
              InkWell(
                onTap: () {
                  controller.pickImage();
                },
                child: Container(
                  height: 140 * size,
                  width: 140 * size,
                  decoration: BoxDecoration(
                    color: AppColor.secondColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        AppImage.addIcon,
                        height: 50 * size,
                        width: 50 * size,
                      ),
                      CommonText(
                        text: 'Upload Post',
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor,
                        fontSize: font * 15,
                      )
                    ],
                  ),
                ),
              )
            else
              InkWell(
                onTap: () {
                  controller.pickImage();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 140 * size,
                  width: 140 * size,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(controller.image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            SizedBox(
              height: 30 * size,
            ),
            CommonTextField(
              controller: controller.eventNameController,
              borderRadius: 20 * size,
              focusedBorderColor: AppColor.borderColor,
              enabledBorderColor: AppColor.borderColor,
              hintText: 'Event Name',
              inputTextSize: font * 15,
              cursorColor: AppColor.mainColor,
              textFieldSize: 16 * size,
            ),
            SizedBox(
              height: 20 * size,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20 * size),
              onTap: () {
                controller.selectDate(context);
              },
              child: Container(
                height: 50 * size,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 20 * size),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20 * size),
                  border: Border.all(
                    color: AppColor.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: controller.selectedDate != null
                          ? '${controller.selectedDate.toString().split(' ').first}'
                          : 'Select Date',
                      fontSize: 16 * font,
                      color: AppColor.textColor,
                    ),
                    SvgPicture.asset(
                      AppImage.calendarIcon,
                      height: 24 * size,
                      width: 24 * size,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20 * size,
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      controller.updateEvent();
                    },
                    child: Container(
                      height: 20 * size,
                      width: 20 * size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isEvent == true
                            ? AppColor.mainColor
                            : AppColor.transparent,
                        border: Border.all(
                          color: AppColor.mainColor,
                        ),
                      ),
                      padding: EdgeInsets.all(2 * size),
                      child: FittedBox(
                        child: Icon(
                          Icons.done,
                          color: controller.isEvent == true
                              ? AppColor.white
                              : AppColor.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 11 * size,
                ),
                CommonText(
                  text: 'Upcoming Event',
                  color: AppColor.textColor,
                  fontSize: font * 15,
                )
              ],
            ),
            SizedBox(
              height: 44 * size,
            ),
            SizedBox(
              height: size * 50,
              width: Get.width,
              child: CommonButton(
                radius: size * 15,
                buttonColor: AppColor.mainColor,
                onPressed: () {
                  controller.addPostToFirebase(context);
                },
                child: CommonText(
                  text: 'Add Post',
                  color: AppColor.black,
                  fontSize: font * 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FOR Banner
class Banner extends StatelessWidget {
  final AddPostController controller;
  final double size;
  final double font;
  const Banner(
      {Key? key,
      required this.controller,
      required this.size,
      required this.font})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 * size),
        child: Column(
          children: [
            SizedBox(
              height: 20 * size,
            ),
            if (controller.bannerImage == null)
              InkWell(
                onTap: () {
                  controller.bannerPickImage();
                },
                child: Container(
                  height: 160 * size,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColor.secondColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        AppImage.addIcon,
                        height: 50 * size,
                        width: 50 * size,
                      ),
                      CommonText(
                        text: 'Upload Banner',
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor,
                        fontSize: font * 20,
                      )
                    ],
                  ),
                ),
              )
            else
              InkWell(
                onTap: () {
                  controller.bannerPickImage();
                },
                child: Container(
                  height: 160 * size,
                  width: Get.width,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(controller.bannerImage!),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            SizedBox(
              height: 30 * size,
            ),
            SizedBox(
              height: size * 50,
              width: Get.width,
              child: CommonButton(
                radius: size * 15,
                buttonColor: AppColor.mainColor,
                onPressed: () {
                  controller.addBannerToFirebase(context);
                },
                child: CommonText(
                  text: 'Add Banner',
                  color: AppColor.black,
                  fontSize: font * 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:admin/common/app_const.dart';
import 'package:admin/common/button.dart';
import 'package:admin/common/color.dart';
import 'package:admin/common/image_path.dart';
import 'package:admin/common/text.dart';
import 'package:admin/controller/edit_post_controller.dart';
import 'package:admin/view/edit_event_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen>
    with SingleTickerProviderStateMixin {
  EditPostController editPostController = Get.put(EditPostController());
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
    return GetBuilder<EditPostController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.transparent,
            bottom: PreferredSize(
              preferredSize: Size(Get.width, 10 * size),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * size),
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
              Event(controller: controller, font: font, size: size),
              Banner(controller: controller, font: font, size: size),
            ],
          ),
        );
      },
    );
  }
}

/// FOR EVENT
class Event extends StatelessWidget {
  final EditPostController controller;
  final double size;
  final double font;
  const Event(
      {Key? key,
      required this.controller,
      required this.size,
      required this.font})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10 * size,
      crossAxisSpacing: 10 * size,
      padding: EdgeInsets.symmetric(horizontal: 20 * size, vertical: 20 * size),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => EditEventScreen(eventName: 'One Piece'));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15 * size),
                child: CachedNetworkImage(
                  height: 200 * size,
                  width: 189 * size,
                  imageUrl: 'https://wallpapercave.com/fwp/wp11771332.jpg',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.error_outline),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.4),
                      highlightColor: Colors.grey.withOpacity(0.2),
                      enabled: true,
                      child: Container(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  vertical: 6 * size, horizontal: 6 * size),
              margin: EdgeInsets.symmetric(
                  horizontal: 15 * size, vertical: 8 * size),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 * size),
                color: AppColor.mainColor,
              ),
              alignment: Alignment.center,
              child: CommonText(
                text: 'One Piece',
                color: AppColor.black,
                overflow: TextOverflow.ellipsis,
                fontSize: 16 * font,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        );
      },
    );
  }
}

/// FOR BANNER
class Banner extends StatelessWidget {
  final EditPostController controller;
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Banner')
          .orderBy('bannerDate', descending: false)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            padding: EdgeInsets.all(20 * size),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 140 * size,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColor.secondColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      height: 200 * size,
                      width: 189 * size,
                      imageUrl: '${snapshot.data!.docs[index]['bannerImage']}',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.error_outline),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.4),
                          highlightColor: Colors.grey.withOpacity(0.2),
                          enabled: true,
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50 * size,
                    width: 70 * size,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          showDeleteDialog1(
                              snapshot.data!.docs[index].id,
                              snapshot.data!.docs[index]['name'],
                              controller,
                              context,
                              size,
                              font);
                        },
                        child: SvgPicture.asset(
                          AppImage.deleteIcon,
                          height: size * 26,
                          width: size * 26,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20 * size,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Server Error'),
          );
        } else {
          return Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(AppImage.loader),
            ),
          );
        }
      },
    );
  }
}

showDeleteDialog1(String? id, String? name, EditPostController controller,
    BuildContext context, double size, double font) {
  return showDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: AppColor.secondColor,
        insetPadding: EdgeInsets.all(20),
        contentPadding: EdgeInsets.all(20),
        shape:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20 * size)),
        children: [
          Column(
            children: [
              CommonText(
                text: 'Are you sure you want to delete this post?',
                fontSize: 14 * font,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 8 * size,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 16 * size,
              ),
              CommonText(
                text:
                    'This is permanent no backup , no restore.\nWe warned, ok?',
                fontSize: 12 * font,
                maxLine: 2,
              ),
              SizedBox(
                height: 16 * size,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      buttonColor: AppColor.mainColor,
                      onPressed: () {
                        controller.deleteBanner(
                            id: id, name: name, context: context);
                      },
                      child: CommonText(text: 'Yes'),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CommonButton(
                      buttonColor: AppColor.textColor,
                      onPressed: () {
                        Get.back();
                      },
                      child: CommonText(
                        text: 'No',
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      );
    },
  );
}

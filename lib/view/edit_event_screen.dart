import 'package:admin/common/app_const.dart';
import 'package:admin/common/button.dart';
import 'package:admin/common/color.dart';
import 'package:admin/common/image_path.dart';
import 'package:admin/common/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class EditEventScreen extends StatefulWidget {
  final String eventName;
  const EditEventScreen({Key? key, required this.eventName}) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height / defaultHeight;
    double font = size * 0.97;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.secondColor,
        leading: Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              AppImage.backIcon,
              height: size * 35,
              width: size * 35,
            ),
          ),
        ),
        title: CommonText(
          text: widget.eventName,
          fontSize: 20 * font,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              AppImage.addIcon,
              height: size * 30,
              width: size * 30,
              color: AppColor.black,
            ),
          ),
          SizedBox(
            width: 20 * size,
          ),
          InkWell(
            onTap: () {
              showDeleteDialog(context, size, font);
            },
            child: SvgPicture.asset(
              AppImage.deleteIcon,
              height: size * 20,
              width: size * 20,
            ),
          ),
          SizedBox(
            width: 20 * size,
          )
        ],
      ),
      body: MasonryGridView.count(
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10 * size,
        crossAxisSpacing: 10 * size,
        padding:
            EdgeInsets.symmetric(horizontal: 20 * size, vertical: 20 * size),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20 * size),
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
              Container(
                height: 40 * size,
                width: 100 * size,
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppImage.editIcon,
                        height: size * 26,
                        width: size * 26,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDeleteDialog(context, size, font);
                      },
                      child: SvgPicture.asset(
                        AppImage.removeIcon,
                        height: size * 26,
                        width: size * 26,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

showDeleteDialog(BuildContext context, double size, double font) {
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
                      onPressed: () {},
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

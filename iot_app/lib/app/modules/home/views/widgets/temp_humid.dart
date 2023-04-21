import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/text_theme.dart';
import '../../controllers/home_controller.dart';

class TempHumidBanner extends GetView<HomeController> {
  @override
  final HomeController controller = Get.put(HomeController());
  final double? horizontalPadding;
  final String? img;
  final String? title;
  final Widget? child;

  TempHumidBanner({super.key, 
    required this.img,
    required this.title,
    required this.horizontalPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.1,
      width: Get.width * 0.42,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding!, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage(
              img!,
            ),
            height: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 4),
              child!,
              const Spacer(flex: 2),
              Text(
                title!,
                style: TextThemes.kSub2HeadTextStyle.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 15,
                ),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ],
      ),
    );
  }
}

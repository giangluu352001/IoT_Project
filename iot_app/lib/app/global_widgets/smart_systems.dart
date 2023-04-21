import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/app/global_widgets/animated_switch.dart';
import 'package:iot_app/app/modules/home/controllers/home_controller.dart';
import 'package:iot_app/app/theme/text_theme.dart';
import 'package:flutter_svg/svg.dart';

class SmartSystem extends StatelessWidget {
  final controller = Get.put(HomeController());
  final Color color;
  final int index;
  final String title;
  final String svg;

  SmartSystem({
    Key? key,
    required this.color,
    required this.index,
    required this.title,
    required this.svg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: Get.width * 0.414,
        width: Get.width * 0.4,
        margin: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.width * 0.06,
                width: Get.width * 0.34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: controller.isToggled[index] ? color.withOpacity(0.45): const Color.fromRGBO(255, 253, 253, 1).withOpacity(0.45)),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.width * 0.4,
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: controller.isToggled[index] ? color: const Color.fromRGBO(255, 253, 253, 1).withOpacity(0.7),
                  boxShadow: [BoxShadow(
                    color: const Color.fromARGB(255, 239, 236, 236).withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 15,
                      left: Get.width * 0.032,
                      child: SvgPicture.asset(
                        svg,
                        colorFilter: ColorFilter.mode(controller.isToggled[index] ? Colors.white: Colors.black, BlendMode.srcIn), 
                        height: Get.width * 0.16,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 15,
                      child: AnimatedSwitch(
                        isToggled: controller.isToggled,
                        index: index,
                        onTap: () {
                          controller.onSwitched(index);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: 18,
                      child: Text(
                        title,
                        style: TextThemes.kSub2HeadTextStyle.copyWith(
                          color: controller.isToggled[index] ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

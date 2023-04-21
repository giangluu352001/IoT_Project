import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // animation controller for lottie
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    // splash animation config
    animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(
          const Duration(milliseconds: 1000),
          () => Get.off(() => HomeView()),
        );
      }
    });
  }


  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

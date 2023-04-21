import 'package:get/get.dart';
import 'package:iot_app/app/modules/home/bindings/home_binding.dart';
import 'package:iot_app/app/modules/home/views/home_view.dart';
import 'package:iot_app/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:iot_app/app/modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splashscreen;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.splashscreen,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
  ];
}

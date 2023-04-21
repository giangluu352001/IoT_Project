import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/app/global_widgets/smart_systems.dart';
import 'package:iot_app/app/global_widgets/user_avathar.dart';
import 'package:iot_app/app/modules/home/controllers/home_controller.dart';
import 'package:iot_app/app/modules/home/views/widgets/chart.dart';
import 'package:iot_app/app/theme/text_theme.dart';
import 'widgets/temp_humid.dart';

class HomeView extends GetView<HomeController> {
  @override
  final HomeController controller = Get.put(HomeController());
  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.fromARGB(255, 157, 157, 193),
               Color.fromARGB(255, 255, 255, 255)]),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: size.height * 0.08),
            GetBuilder<HomeController>(
              id: 7,
              builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome,\n${controller.userName}',
                      style: TextThemes.kSubHeadTextStyle
                          .copyWith(color: Colors.black),
                    ),
                    GestureDetector(
                      child: UserAvatar(
                        radius: size.width * 0.06,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      color: Colors.white
                    ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Living room',
                              style: TextThemes.kSub2HeadTextStyle
                                .copyWith(color: Colors.black87),
                            ),
                            Text(
                              'Bathroom',
                              style: TextThemes.kSub2HeadTextStyle
                                .copyWith(color: Colors.grey),
                            ),
                            Text(
                              'Kitchen',
                              style: TextThemes.kSub2HeadTextStyle
                                .copyWith(color: Colors.grey),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<String>(
                              stream: controller.tempStream.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return TempHumidBanner(
                                    img: 'assets/icons/temperature.png',
                                    title: 'Temperature',
                                    horizontalPadding: Get.width * 0.01,
                                    child: const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )
                                    ),
                                  );
                                } else { 
                                  int value;
                                  snapshot.data! == 'nan'
                                      ? value = 0
                                      : value = double.parse(snapshot.data!).toInt();
                                  return TempHumidBanner(
                                    img: 'assets/icons/temperature.png',
                                    title: 'Temperature',
                                    horizontalPadding: Get.width * 0.01,
                                    child: Text(
                                      '$value°C',
                                      style: TextThemes.kSub2HeadTextStyle
                                          .copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            StreamBuilder<String>(
                              stream: controller.humidStream.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.connectionState == ConnectionState.waiting) {
                                  return TempHumidBanner(
                                    img: 'assets/icons/humidity.png',
                                    title: 'Humidity',
                                    horizontalPadding: Get.width * 0.025,
                                    child: const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )
                                    ),
                                  );
                                } else {
                                  int value;
                                  snapshot.data! == 'nan'
                                      ? value = 0
                                      : value = double.parse(snapshot.data!).toInt();
                                  return TempHumidBanner(
                                    img: 'assets/icons/humidity.png',
                                    title: 'Humidity',
                                    horizontalPadding: Get.width * 0.025,
                                    child: Text( 
                                      '$value%',
                                      style: TextThemes.kSub2HeadTextStyle
                                          .copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      GetBuilder<HomeController>(
                        id: 2,
                        builder: (_) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder(
                                    stream: controller.lightStream.stream,
                                    builder:(context, snapshot) {
                                      if (snapshot.hasData) {
                                        controller.toggle(0, snapshot.data);
                                      }
                                      return SmartSystem(
                                        color: Colors.redAccent,
                                        index: 0,
                                        title: 'LIGHT',
                                        svg: 'assets/images/led-light.svg',
                                      );
                                  }
                                  ),
                                   StreamBuilder(
                                    stream: controller.pumpStream.stream,
                                    builder:(context, snapshot) {
                                      if (snapshot.hasData) {
                                        controller.toggle(1, snapshot.data);
                                      }
                                      return SmartSystem(
                                        color: Colors.blueAccent,
                                        index: 1,
                                        title: 'PUMP',
                                        svg: 'assets/images/water-pump.svg',
                                      );
                                    }
                                   )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      GetBuilder<HomeController>(
                        id: 3,
                        builder: (_) {
                          final Widget chartWidget = controller.chartData.isNotEmpty
                                ? TemperatureChart()
                                : const Center(child: CircularProgressIndicator());
                          return Column(
                            children: [ chartWidget ]
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
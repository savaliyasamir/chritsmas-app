
// ignore_for_file: avoid_print, await_only_futures

import 'package:Santa_prank_call/widget/PushNotificationService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/splash_screen.dart';

final getStorage = GetStorage();

void main() async {
  await GetStorage.init();
  PushNotificationService().setupInteractedMessage();

  await WidgetsFlutterBinding.ensureInitialized();
  // FacebookAudienceNetwork.init();

  await MobileAds.instance.initialize().then(
        (InitializationStatus status) {
          //
          // MobileAds.instance.updateRequestConfiguration(
          //     RequestConfiguration(testDeviceIds: ['62F2ECEE3F0FB8C2AB1CDEDC2F1EAFC8']));
          // FacebookAudienceNetwork.init(
          //   testingId: "7d153f85-2d3f-4643-868c-f8fd1c1e31dc",
          //
          // );
      debugPrint('Initialization done: ${status.adapterStatuses}');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), /*VideoPlayerScreen(
        videoUrl: "assets/new_video.mp4",
      ),*/
    );

  }

}
Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();

  if (status.isGranted) {
    print("Notification permission granted");
  } else {
    print("Notification permission denied");
  }
}
///chirtsmas:///
//200577472
///easy emi:
///200972507
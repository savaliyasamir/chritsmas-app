
import 'package:Santa_prank_call/widget/PushNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
final getStorage = GetStorage();

void main() async {

  await GetStorage.init();
  PushNotificationService().setupInteractedMessage();

  WidgetsFlutterBinding.ensureInitialized();
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), /*VideoPlayerScreen(
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

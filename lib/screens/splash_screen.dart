import 'dart:convert';


import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late VideoPlayerController _videoPlayerController;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;


  @override
  void initState() {
    _callNativeAd();
    appOpenAdManager.loadAd();

    Future.delayed(const Duration(milliseconds: 5500)).then((value) {
      appOpenAdManager.showAdIfAvailable();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionScreen(),
        ),
      );
    });


    availableCameras().then((cameras) {
      // Find the front camera in the list of available cameras
      CameraDescription frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // Initialize the controller with the front camera
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.veryHigh,
      );

      // Initialize the controller future asynchronously.
      _initializeControllerFuture = _controller.initialize(); // Initialize _initializeControllerFuture here
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/splash_screen_img.png",fit: BoxFit.cover,)),
      ),
    );
  }
  _callNativeAd() async  {
    final String url = 'https://abvengineering.in/addata/adone.html';
    // final String url = "https://aercal.in/adapifile/callprank.html";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        String DisclamierLink = data[0]["app_disclaimerlink"];
        String TermsLink = data[0]["app_Termslink"];
        getStorage.write("DisclamierLink", DisclamierLink);
        getStorage.write("TermsLink", TermsLink);
        String nad2Value = data[0]["nad2"];
        adType  = data[0]['btype'];
        String BannerAdId = data[0]["bad"];
        String InterStialAdId = data[0]["iad"];
        String OpenAdID = data[0]["oad"];
        String tapCount = data[0]["adscount"];
        String FbInAdId = data[0]["fiad"];
        String FbNAdId = data[0]["fnad"];
        String FbBaAdId = data[0]["fbad"];
        getStorage.write("FbNAdId",FbNAdId);
        getStorage.write("FbBaAdId", FbBaAdId);
        getStorage.write("NativAdId", nad2Value);
        getStorage.write("FbInAdId", FbInAdId);
        getStorage.write("tapCount", tapCount);
        getStorage.write("BannerAdId", BannerAdId);
        getStorage.write("InterStialAdId", InterStialAdId);
        getStorage.write("OpenAdID", OpenAdID);
        // Printing the values (you can use these variables in your Flutter code)
        print("nad2: $nad2Value");
        print("BAnnerAdID: $BannerAdId,");
        print("InterStialAdId : , $InterStialAdId");
        print("OpenAdID, $OpenAdID");
        print("DisclamierLink, $DisclamierLink");
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



}

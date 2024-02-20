import 'dart:convert';

import 'package:Santa_prank_call/main.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
Color? PinkColor = Color(0xffF8C2C2);
Color? textcolor = Color(0xff851D1B);
void showSnackBarWithTitleAndText(String title, String message) {
  Get.snackbar(title, message,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent  /*.withOpacity(0.5)*/,
      animationDuration: Duration(milliseconds: 500),
      duration: Duration(seconds: 2));
}
void showValidationSnackBar(String? message) {
  showSnackBar(title: "Alert", msg: message!);
}
showSnackBar({required String title, required String msg}){
  Get.snackbar(title, msg,
      colorText: Colors.red,
      backgroundColor: Colors.white);
}
String InterstialAdID = getStorage.read("InterStialAdId") ?? "";
String facebookBannerAdId = getStorage.read("FbBaAdId") == "" ? "IMG_16_9_APP_INSTALL#1077658573437041_1077659073436991" : getStorage.read("FbBaAdId");
String facebookNativeAdPlacementID = getStorage.read("FbNAdId") == "" ? "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650" : getStorage.read("FbNAdId");
String FacebookInterstailAdId = getStorage.read("FbInAdId") == "" ? "IMG_16_9_APP_INSTALL#1077658573437041_1077659113436987" : getStorage.read("FbInAdId");
// String facebookNativeAdPlacementID =  "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650";

Widget currentFacebookNativeAd = SizedBox(
  width: 0.0,
  height: 0.0,
);

class MyHeight {
  static double getHeight(BuildContext context, double percentage) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percentage / 100.0;
  }
  static double getWidth(BuildContext context, double percentage) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * percentage / 100.0;
  }
}

Widget facebookNativeAd() {
  return FacebookNativeAd(
    placementId: facebookNativeAdPlacementID,
    adType: NativeAdType.NATIVE_AD_VERTICAL,
    width: double.infinity,
    height: 300,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Ad: $result --> $value");
      if (result == NativeAdResult.ERROR) {

      }
      if(result == NativeAdResult.LOADED){
        currentFacebookNativeAd = facebookNativeAd();
      }
    },
    keepExpandedWhileLoading: true,
    expandAnimationDuraion: 1000,
  );
}
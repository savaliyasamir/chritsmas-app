import 'dart:convert';

import 'package:Santa_prank_call/main.dart';
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
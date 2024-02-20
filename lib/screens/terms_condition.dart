// ignore_for_file: avoid_print, prefer_if_null_operators, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace

import 'dart:ffi';

import 'package:Santa_prank_call/controller/ads_controller.dart';
import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/call_type_screen.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/ad_helper.dart';

String? adType;

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen>
    with WidgetsBindingObserver {
  var myContr = Get.put(MyController());
  bool value = false;
  bool value1 = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  final Uri _disclamierLink = Uri.parse(getStorage.read("DisclamierLink"));
  final Uri _termsLink = Uri.parse(getStorage.read("TermsLink"));

  @override
  void initState() {
    super.initState();
    myContr.loadAd();
    FacebookAudienceNetwork.init(
        testingId: "b9e30477-c79b-4ca4-8253-3f7bb676dd4ec");
    appOpenAdManager.loadAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    myContr.isAdLoaded.value = false;
    myContr.disposeNAtiveAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                decoration: BoxDecoration(
                    color: PinkColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100))),
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          "Terms & Service",
                          style: TextStyle(
                              fontSize: 27,
                              color: textcolor,
                              fontWeight: FontWeight.bold),
                        )),
                    Row(
                      children: [
                        const Spacer(),
                        Image.asset(
                          "assets/download__6_-removebg-preview.png",
                          height: 139,
                          width: 170,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        value = !value;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: PinkColor,
                          border: Border.all(color: const Color(0xff851D1B))),
                      child: value == true
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchUrl(_termsLink.toString());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        "Kindly review our comprehensive Terms \nand Condition",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        value1 = !value1;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: PinkColor,
                          border: Border.all(color: const Color(0xff851D1B))),
                      child: value1 == true
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchUrl(_disclamierLink.toString());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        "Please take a moment to review our\nDisclaimer statement",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (adType == "1") {
                    AdHelper.showInterstitialAd(
                      onComplete: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CallTypeScreen()));
                      },
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CallTypeScreen()));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: const Text(
                    "Let's go",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              adType == "1"
                  ? Obx(
                      () => Container(
                        height: MyHeight.getHeight(context, 46),
                        child: myContr.isAdLoaded.value
                            ? AdWidget(ad: myContr.nativeAd!)
                            : Container(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url.toString()))) {
      return showSnackBarWithTitleAndText(
          "Alert", "There is no terms and condition right now");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }
}

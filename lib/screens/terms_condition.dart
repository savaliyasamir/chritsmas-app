import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/call_type_screen.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> with WidgetsBindingObserver{
  bool value = false;
  bool value1 = false;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  String? _versionString;
  InterstitialAd? _interstitialAd;
  int _tapCounter = 0;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool isAdLoading = false;

  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  final Uri _disclamierLink = Uri.parse(getStorage.read("DisclamierLink"));
  final Uri _termsLink = Uri.parse(getStorage.read("TermsLink"));


  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    _loadAd();
    _loadVersionString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: PinkColor/*Color(0xff2B75B0)*/,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*  SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),*/
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04,
              ),
              decoration: BoxDecoration(
                  color: PinkColor,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              height: MediaQuery.of(context).size.height * 0.28,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        "Terms & Service",
                        style: TextStyle(
                            fontSize: 27,
                            color: textcolor,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: [
                      Spacer(),
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
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
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
                        border: Border.all(color: Color(0xff851D1B))),
                    child: value == true
                        ? Icon(
                            Icons.check_rounded,
                            size: 18,
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl(_termsLink.toString());
                    },
                    child: Text(
                      "Kindly review our comprehensive Terms \nand Condition",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
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
                        border: Border.all(color: Color(0xff851D1B))),
                    child: value1 == true
                        ? Icon(
                            Icons.check_rounded,
                            size: 18,
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl(_disclamierLink.toString());
                    },
                    child: Text(
                      "Please take a moment to review our\nDisclaimer statement",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Please read our Terms and Conditions",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "Please read our Disclaimer",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {

                if (value == false || value1 == false) {
                  showValidationSnackBar(
                    "Please Accept the terms and conditions!",
                  );
                } else {

                    if (!isAdLoading) {
                      _loadAdInterstial();
                    }
                    // _showRewardedInterstitialAd();

                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.red),
                child: Text("Let's go",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            if (_nativeAdIsLoaded && _nativeAd != null)
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: AdWidget(ad: _nativeAd!)),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    _tapCounter++;
    if (_tapCounter % int.parse(getStorage.read("tapCount").toString()) == 0) {
      _loadAdInterstial();
    }
  }

  void _loadAdInterstial() {
 isAdLoading = true;

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallTypeScreen()));
              ad.dispose();
               isAdLoading = false;

            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CallTypeScreen()));
                isAdLoading = false;// Dispose only when ad is dismissed
              });
            },
            onAdClicked: (ad) {},
          );

          setState(() {
            ad.show();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CallTypeScreen()));
          isAdLoading = false;
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Loads a native ad.
  void _loadAd() {
    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
        adUnitId: getStorage.read("NativAdId") == null
            ? ""
            : getStorage.read("NativAdId"),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: const Color(0xfffffbed),
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void _loadVersionString() {
    MobileAds.instance.getVersionString().then((value) {
      setState(() {
        _versionString = value;
      });
    });
  }
  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url.toString()))) {
     return showSnackBarWithTitleAndText("Alert", "There is no terms and condition right now");
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
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

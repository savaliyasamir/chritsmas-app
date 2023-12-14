import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/accept_policy.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

class CallTypeScreen extends StatefulWidget {
  const CallTypeScreen({Key? key}) : super(key: key);

  @override
  State<CallTypeScreen> createState() => _CallTypeScreenState();
}

class _CallTypeScreenState extends State<CallTypeScreen>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool isInterstitialAdLoaded = false;
  StartAppBannerAd? startAppBannerAd;
  String? _versionString;
  StartAppBannerAd? mrecAd;
  StartAppInterstitialAd? startAppInterstitialAd;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);
  int _tapCounter = 0;
  bool isAdLoading = false;
  var startAppSdk = StartAppSdk();

  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    _loadInterstitialAds();
    startAppSdk.setTestAdsEnabled(true);
    FacebookAudienceNetwork.init();
    _showFacebookNativeAd();

    WidgetsBinding.instance.addObserver(this);
    _loadAd();
    _loadVersionString();
    if (adType == "1") {
      startAppSdk
          .loadBannerAd(
        StartAppBannerType.BANNER,
        prefs: const StartAppAdPreferences(adTag: 'secondary'),
      )
          .then((mrecAd) {
        setState(() {
          this.mrecAd = mrecAd;
        });
      }).onError<StartAppException>((ex, stackTrace) {
        debugPrint("Error loading Mrec ad: ${ex.message}");
      }).onError((error, stackTrace) {
        debugPrint("Error loading Mrec ad: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              padding: EdgeInsets.only(right: 15, left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hi, samantha!",
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Thanks for choosing our app,Get\nready to experience seamless\ncommunication and stay connected\nwith those who matter most!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.37,
              width: MediaQuery.of(context).size.width,
              color: PinkColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Connect Your Way",
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 170,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage("assets/voice_img.png"),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Audio Call",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 150,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 170,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/Voice_call_img.png"),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Video Call",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  FacebookInterstitialAd.showInterstitialAd();
                  // if (adType == "1") {
                  //   try {
                  //     await startAppSdk.loadInterstitialAd(
                  //       prefs: const StartAppAdPreferences(adTag: 'home_screen'),
                  //       onAdDisplayed: () {
                  //         debugPrint('onAdDisplayed: interstitial');
                  //       },
                  //
                  //       onAdNotDisplayed: () {
                  //         debugPrint('onAdNotDisplayed: interstitial');
                  //
                  //         // NOTE interstitial ad can be shown only once
                  //         this.startAppInterstitialAd?.dispose();
                  //         this.startAppInterstitialAd = null;
                  //       },
                  //       onAdClicked: () {
                  //         debugPrint('onAdClicked: interstitial');
                  //       },
                  //       onAdHidden: () {
                  //         debugPrint('onAdHidden: interstitial');
                  //
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => AcceptPolicyScreen()));
                  //         this.startAppInterstitialAd?.dispose();
                  //         this.startAppInterstitialAd = null;
                  //       },
                  //     ).then((interstitialAd) {
                  //       this.startAppInterstitialAd = interstitialAd;
                  //       interstitialAd?.show();
                  //     });
                  //   } on StartAppException catch (ex) {
                  //     debugPrint("Error loading or showing Interstitial ad: ${ex.message}");
                  //   } catch (error, stackTrace) {
                  //     debugPrint("Error loading or showing Interstitial ad: $error");
                  //   }
                  // }else{
                  //   if (!isAdLoading) {
                  //     _loadAdInterstial();
                  //   }
                  // }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red),
                  child: Text("Let's go",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
SizedBox(height: 40,),
            /// show Facebook native ad
            Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: currentFacebookNativeAd),
            /*Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width,
                child: (adType == "1" && mrecAd != null)
                    ? StartAppBanner(mrecAd!)
                    : (_nativeAdIsLoaded && _nativeAd != null)
                    ? Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  child: AdWidget(ad: _nativeAd!),
                )
                    : SizedBox()),*/
          ],
        ),
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
            templateType: TemplateType.small,
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
              ad.dispose();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AcceptPolicyScreen()));
            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AcceptPolicyScreen()));
                isAdLoading = false; // Dispose only when ad is dismissed
              });
            },
            onAdClicked: (ad) {},
          );

          setState(() {
            ad.show();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AcceptPolicyScreen()));
          isAdLoading = false;
        },
      ),
    );
  }

  /// facebook native ad

  Widget currentFacebookNativeAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  _showFacebookNativeAd() {
    setState(() {
      currentFacebookNativeAd = facebookNativeAd();
    });
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
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }

  _handleTap() {
    _tapCounter++;
    if (_tapCounter % int.parse(getStorage.read("tapCount").toString()) == 0) {
      _loadAdInterstial();
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
  void _loadInterstitialAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#1077658573437041_1077659113436987",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED ) {
          isInterstitialAdLoaded = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AcceptPolicyScreen()));
          _loadInterstitialAds();
        }
      },
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
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

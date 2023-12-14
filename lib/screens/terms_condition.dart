import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/call_type_screen.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

String? adType;

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen>
    with WidgetsBindingObserver {
  bool value = false;
  bool value1 = false;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  NativeAd? _nativeAd;
  StartAppInterstitialAd? startAppInterstitialAd;

  bool _nativeAdIsLoaded = false;
  String? _versionString;
  InterstitialAd? _interstitialAd;
  int _tapCounter = 0;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool isAdLoading = false;
  bool isLoadingIo = false;

  bool isButtonTapped = false;
  bool facebookNativeAdError = false;

  bool isInterstitialAdLoaded = false;
  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  final Uri _disclamierLink = Uri.parse(getStorage.read("DisclamierLink"));
  final Uri _termsLink = Uri.parse(getStorage.read("TermsLink"));
  StartAppBannerAd? mrecAd;

  var startAppSdk = StartAppSdk();

  StartAppBannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
    appOpenAdManager.loadAd();
    _loadAd();

    /// Ad type 1 = google Ad
    if (adType == "1") {
      _loadVersionString();

    }

    /// Ad type 2 = Facebook Ad
    if (adType == "2") {
      _showFacebookNativeAd();
      _loadInterstitialAds();
    }

    /// Ad type 3 = start.io Ad

    if (adType == "3") {
      startAppSdk
          .loadBannerAd(
        StartAppBannerType.MREC,
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
          children: [
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
                  child: Text(
                    "Kindly review our comprehensive Terms \nand Condition",
                    style: TextStyle(
                      fontSize: 17,
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
                  child: Text(
                    "Please take a moment to review our\nDisclaimer statement",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _launchUrl(_termsLink.toString());
              },
              child: Center(
                child: Text(
                  "Please read our Terms and Conditions",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _launchUrl(_disclamierLink.toString());
              },
              child: Center(
                child: Text(
                  "Please read our Disclaimer",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                isButtonTapped = true;
                if (value == false || value1 == false) {
                  showValidationSnackBar(
                    "Please Accept the terms and conditions!",
                  );
                } else {
                  if (adType == "1" && !isLoadingIo) {
                    _loadAdInterstial();
                  } else if (adType == "2") {
                    _loadInterstitialAds();
                    FacebookInterstitialAd.showInterstitialAd();
                  } else if (adType == "3") {
                    if (!isLoadingIo) {
                      try {
                        isLoadingIo = true;
                        await startAppSdk
                            .loadInterstitialAd(
                          prefs:
                              const StartAppAdPreferences(adTag: 'home_screen'),
                          onAdDisplayed: () {
                            debugPrint('onAdDisplayed: interstitial');
                          },
                          onAdNotDisplayed: () {
                            debugPrint('onAdNotDisplayed: interstitial');

                            // NOTE interstitial ad can be shown only once
                            this.startAppInterstitialAd?.dispose();
                            this.startAppInterstitialAd = null;
                            isLoadingIo = false;
                          },
                          onAdClicked: () {
                            debugPrint('onAdClicked: interstitial');
                            isLoadingIo = false;
                          },
                          onAdHidden: () {
                            debugPrint('onAdHidden: interstitial');
                            isLoadingIo = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CallTypeScreen()));
                            this.startAppInterstitialAd?.dispose();
                            this.startAppInterstitialAd = null;
                          },
                        )
                            .then((interstitialAd) {
                          this.startAppInterstitialAd = interstitialAd;
                          interstitialAd?.show();
                        });
                      } on StartAppException catch (ex) {
                        isLoadingIo = false;
                        debugPrint(
                            "Error loading or showing Interstitial ad: ${ex.message}");
                      } catch (error, stackTrace) {
                        debugPrint(
                            "Error loading or showing Interstitial ad: $error");
                      }
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallTypeScreen()));
                  }
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
                child: Text(
                  "Let's go",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: (adType == "1" &&  (_nativeAdIsLoaded && _nativeAd != null))
                  ? AdWidget(ad: _nativeAd!)
                  : (adType == "2")
                      ?  (facebookNativeAdError == true ? AdWidget(ad: _nativeAd!) : currentFacebookNativeAd)
                      : ((adType == "3" && mrecAd != null)
                              ? StartAppBanner(mrecAd!)
                              : (_nativeAdIsLoaded && _nativeAd != null)
                                  ? SizedBox()
                                  : null)
            ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CallTypeScreen()));
              ad.dispose();
              isAdLoading = false;
            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CallTypeScreen()));
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CallTypeScreen()));
          isAdLoading = false;
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Loads a google native ad.

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
      return showSnackBarWithTitleAndText(
          "Alert", "There is no terms and condition right now");
    }
  }

  /// facebook interestial ad

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
        if (result == InterstitialAdResult.ERROR && isButtonTapped == true) {
          setState(() {
            _loadAdInterstial();
            isButtonTapped = false;
          });
        }
        if (result == InterstitialAdResult.DISMISSED) {
          isInterstitialAdLoaded = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CallTypeScreen()));
          _loadInterstitialAds();
        }
      },
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
        if (result == NativeAdResult.ERROR) {
          setState(() {
            facebookNativeAdError = true;
          });
        }
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
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

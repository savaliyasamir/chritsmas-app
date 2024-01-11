import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/select_country.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

class AcceptPolicyScreen extends StatefulWidget {
  const AcceptPolicyScreen({Key? key}) : super(key: key);

  @override
  State<AcceptPolicyScreen> createState() => _AcceptPolicyScreenState();
}

class _AcceptPolicyScreenState extends State<AcceptPolicyScreen>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool isInterstitialAdLoaded = false;
  bool isAdLoading = false;
  StartAppInterstitialAd? startAppInterstitialAd;
  bool _nativeAdIsLoaded = false;
  bool isLoadingIo = false;


  bool isButtonTapped = false;
  bool facebookNativeAdError = false;

  var startAppSdk = StartAppSdk();
  String? _versionString;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';

  InterstitialAd? _interstitialAd;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  int _tapCounter = 0;
  StartAppBannerAd? mrecAd;
  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);

  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    _loadInterstitialAds();
    FacebookAudienceNetwork.init();
    WidgetsBinding.instance.addObserver(this);
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
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: PinkColor,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/share_ic.png",
                                fit: BoxFit.cover, height: 70, width: 70),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Share",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/review_ic.png",
                                fit: BoxFit.cover, height: 70, width: 70),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Rate Us",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/download_ic.png",
                                fit: BoxFit.cover, height: 70, width: 70),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Privacy",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/option_ic.png",
                                fit: BoxFit.cover, height: 70, width: 70),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "More",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                isButtonTapped = true;

                if (adType == "1") {
                  if(!isAdLoading){
                    _loadAdInterstial();
                  }
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
                                  builder: (context) => SelectCountriescreen()));
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
                          builder: (context) => AcceptPolicyScreen()));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.48,
                width: MediaQuery.of(context).size.width,
                child: (adType == "1" &&  (_nativeAdIsLoaded && _nativeAd != null))
                    ? AdWidget(ad: _nativeAd!)
                    : (adType == "2")
                    ?  (facebookNativeAdError == true &&  (_nativeAdIsLoaded && _nativeAd != null) ? AdWidget(ad: _nativeAd!) : currentFacebookNativeAd)
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

  void _handleTap() {
    _tapCounter++;
    if (_tapCounter % int.parse(getStorage.read("tapCount").toString()) == 0) {
      _loadAdInterstial();
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
              MaterialPageRoute(builder: (context) => SelectCountriescreen()));
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
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
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
                      builder: (context) => SelectCountriescreen()));
              isAdLoading = false;
            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectCountriescreen()));
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectCountriescreen()));
          print('InterstitialAd failed to load: $error');
          isAdLoading = false;
        },
      ),
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

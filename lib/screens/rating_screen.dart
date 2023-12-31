import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

import '../widget/constant.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool isAdLoading = false;
  bool isInterstitialAdLoaded = false;
  bool facebookNativeAdError = false;
  bool isButtonTapped = false;
  String? _versionString;
  InterstitialAd? _interstitialAd;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  int _tapCounter = 0;
  StartAppBannerAd? mrecAd;
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? startAppInterstitialAd;

  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);

  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    startAppSdk.setTestAdsEnabled(true);
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
    _loadVersionString();

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
    Future<bool> _onBackPressed() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    exit(0);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                  color: PinkColor,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(100)),
                ),
                child: Text(
                  "How was your experience?",
                  style: TextStyle(
                      fontSize: 27,
                      color: textcolor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                itemSize: 50,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.orangeAccent,
                ),
                unratedColor: Colors.black12,
                onRatingUpdate: (rating) {},
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Rate your video call on a\nscale of 1 to 5.",
                style: TextStyle(
                    color: textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "Your feedback helps us to improve!.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      isButtonTapped = true;
                      if (adType == "1") {
                        if (!isAdLoading) {
                          _loadAdInterstial();
                        }
                      } else if (adType == "2") {
                        _loadInterstitialAds();
                        FacebookInterstitialAd.showInterstitialAd();
                      } else if (adType == "3") {
                        try {
                          await startAppSdk
                              .loadInterstitialAd(
                            prefs: const StartAppAdPreferences(
                                adTag: 'home_screen'),
                            onAdDisplayed: () {
                              debugPrint('onAdDisplayed: interstitial');
                            },
                            onAdNotDisplayed: () {
                              debugPrint('onAdNotDisplayed: interstitial');

                              // NOTE interstitial ad can be shown only once
                              this.startAppInterstitialAd?.dispose();
                              this.startAppInterstitialAd = null;
                            },
                            onAdClicked: () {
                              debugPrint('onAdClicked: interstitial');
                            },
                            onAdHidden: () {
                              debugPrint('onAdHidden: interstitial');

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SeletctCategerioesScreen()),
                                      (route) => false);
                              this.startAppInterstitialAd?.dispose();
                              this.startAppInterstitialAd = null;
                            },
                          )
                              .then((interstitialAd) {
                            this.startAppInterstitialAd = interstitialAd;
                            interstitialAd?.show();
                          });
                        } on StartAppException catch (ex) {
                          debugPrint(
                              "Error loading or showing Interstitial ad: ${ex.message}");
                        } catch (error, stackTrace) {
                          debugPrint(
                              "Error loading or showing Interstitial ad: $error");
                        }
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SeletctCategerioesScreen()),
                                (route) => false);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: PinkColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            color: textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      isButtonTapped = true;
                      if (adType == "1") {
                        if (!isAdLoading) {
                          _loadAdInterstial();
                        }
                      } else if (adType == "2") {
                        _loadInterstitialAds();
                        FacebookInterstitialAd.showInterstitialAd();
                      } else if (adType == "3") {
                        try {
                          await startAppSdk
                              .loadInterstitialAd(
                            prefs: const StartAppAdPreferences(
                                adTag: 'home_screen'),
                            onAdDisplayed: () {
                              debugPrint('onAdDisplayed: interstitial');
                            },
                            onAdNotDisplayed: () {
                              debugPrint('onAdNotDisplayed: interstitial');

                              // NOTE interstitial ad can be shown only once
                              this.startAppInterstitialAd?.dispose();
                              this.startAppInterstitialAd = null;
                            },
                            onAdClicked: () {
                              debugPrint('onAdClicked: interstitial');
                            },
                            onAdHidden: () {
                              debugPrint('onAdHidden: interstitial');

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SeletctCategerioesScreen()),
                                  (route) => false);
                              this.startAppInterstitialAd?.dispose();
                              this.startAppInterstitialAd = null;
                            },
                          )
                              .then((interstitialAd) {
                            this.startAppInterstitialAd = interstitialAd;
                            interstitialAd?.show();
                          });
                        } on StartAppException catch (ex) {
                          debugPrint(
                              "Error loading or showing Interstitial ad: ${ex.message}");
                        } catch (error, stackTrace) {
                          debugPrint(
                              "Error loading or showing Interstitial ad: $error");
                        }
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SeletctCategerioesScreen()),
                            (route) => false);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: PinkColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
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
      )
    );
  }

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
              ad.dispose();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeletctCategerioesScreen()),
                  (route) => false);
              isAdLoading = false;
            },
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeletctCategerioesScreen()),
                  (route) => false);
              setState(() {
                ad.dispose();
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SeletctCategerioesScreen()),
              (route) => false);
          isAdLoading = false;
        },
      ),
    );
  }

  void _loadInterstitialAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#1077658573437041_1077659113436987",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          isInterstitialAdLoaded = true;
        if (result == InterstitialAdResult.ERROR && isButtonTapped == true) {
          setState(() {
            _loadAdInterstial();
            isButtonTapped = false;
          });
        }

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED) {
          isInterstitialAdLoaded = false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SeletctCategerioesScreen()),
              (route) => false);
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

  _showNativeBannerAd() {
    setState(() {
      _currentAd = _nativeBannerAd();
    });
  }

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  Widget _nativeBannerAd() {
    return FacebookNativeAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Banner Ad: $result --> $value");
      },
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

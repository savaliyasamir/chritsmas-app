import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';

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

    if (adType == "1") {
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

    WidgetsBinding.instance.addObserver(this);
    _loadAd();
    _loadVersionString();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() async {
      return await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
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
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
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
                  itemBuilder: (context, _) =>
                      Icon(
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
                        if (adType == "1") {
                          try {
                            await startAppSdk.loadInterstitialAd(
                              prefs: const StartAppAdPreferences(adTag: 'home_screen'),
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

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        SeletctCategerioesScreen()));
                                this.startAppInterstitialAd?.dispose();
                                this.startAppInterstitialAd = null;
                              },
                            ).then((interstitialAd) {
                              this.startAppInterstitialAd = interstitialAd;
                              interstitialAd?.show();
                            });
                          } on StartAppException catch (ex) {
                            debugPrint("Error loading or showing Interstitial ad: ${ex
                                .message}");
                          } catch (error, stackTrace) {
                            debugPrint(
                                "Error loading or showing Interstitial ad: $error");
                          }
                        } else {
                          if (!isAdLoading) {
                            _loadAdInterstial();
                          }
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
                        if (adType == "1") {
                          try {
                            await startAppSdk.loadInterstitialAd(
                              prefs: const StartAppAdPreferences(adTag: 'home_screen'),
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

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        SeletctCategerioesScreen()));
                                this.startAppInterstitialAd?.dispose();
                                this.startAppInterstitialAd = null;
                              },
                            ).then((interstitialAd) {
                              this.startAppInterstitialAd = interstitialAd;
                              interstitialAd?.show();
                            });
                          } on StartAppException catch (ex) {
                            debugPrint("Error loading or showing Interstitial ad: ${ex
                                .message}");
                          } catch (error, stackTrace) {
                            debugPrint(
                                "Error loading or showing Interstitial ad: $error");
                          }
                        } else {
                          if (!isAdLoading) {
                            _loadAdInterstial();
                          }
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
                Spacer(),

                Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: (adType == "1" && mrecAd != null)
                        ? StartAppBanner(mrecAd!)
                        : (_nativeAdIsLoaded && _nativeAd != null)
                        ? Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: AdWidget(ad: _nativeAd!),
                    )
                        : SizedBox()),          ],
            ),
          ),
        ),
      ),);
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

  @override
  void dispose() {
    _nativeAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

}

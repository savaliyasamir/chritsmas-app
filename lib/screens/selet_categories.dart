import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/SorryScreen.dart';
import 'package:Santa_prank_call/screens/select_partner_for_vc.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:startapp_sdk/startapp.dart';

import '../widget/constant.dart';

class SeletctCategerioesScreen extends StatefulWidget {
  const SeletctCategerioesScreen({Key? key}) : super(key: key);

  @override
  State<SeletctCategerioesScreen> createState() =>
      _SeletctCategerioesScreenState();
}

class _SeletctCategerioesScreenState extends State<SeletctCategerioesScreen>
    with WidgetsBindingObserver {
  bool isAdLoaded = false;
  bool isInterstitialAdLoaded = false;
  // StartAppInterstitialAd? startAppInterstitialAd;
  // var startAppSdk = StartAppSdk();
  bool isAdLoading = false;
  bool isLoadingIo = false;
  List<String> _videoCallerList = [
    "assets/ic_santa.png",
    "assets/ic_cricket.png",
    "assets/ic_football.png",
    "assets/ic_singer.png",
    "assets/ic_influencer.png"
  ];
  late BannerAd _bannerAd;
  bool isButtonTapped = false;
  // StartAppBannerAd? startAppBannerAd;
  // StartAppBannerAd? mrecAd;
  final String adUnitId = Platform.isAndroid
      ? getStorage.read("BannerAdId")
      : 'ca-app-pub-3940256099942544/2934735716';
  int _tapCounter = 0;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  int maxFailedLoadAttempts = 3;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool _isLoaded = false;
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
  @override
  void initState() {
    super.initState();
    // _createRewardedInterstitialAd();
    loadAd();
    appOpenAdManager.loadAd();

    // startAppSdk.setTestAdsEnabled(true);
    WidgetsBinding.instance.addObserver(this);
    if (adType == "2") {
      loadBannerAd();
    }
    if (adType == "2") {
      _loadInterstitialAds();
    }
/*    if (adType == "3") {
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
    }*/
  }

  InterstitialAd? interstitialAd;

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
        body: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: PinkColor,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(100)),
                  ),
                  child: Text(
                    "Select the Category",
                    style: TextStyle(
                        fontSize: 27,
                        color: textcolor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (index == 0) {
                            isButtonTapped = true;
                            if (adType == "1") {
                              if (!isAdLoading) {
                                _loadAdInterstial();
                              }
                            } else if (adType == "2") {
                              _loadInterstitialAds();
                              FacebookInterstitialAd.showInterstitialAd();
                            } /*else if (adType == "3" &&  !isLoadingIo) {
                              try {
                                isLoadingIo = true;
                                await startAppSdk
                                    .loadInterstitialAd(
                                  prefs: const StartAppAdPreferences(
                                      adTag: 'home_screen'),
                                  onAdDisplayed: () {
                                    isLoadingIo = false;
                                    debugPrint('onAdDisplayed: interstitial');
                                  },
                                  onAdNotDisplayed: () {
                                    debugPrint(
                                        'onAdNotDisplayed: interstitial');

                                    // NOTE interstitial ad can be shown only once
                                    this.startAppInterstitialAd?.dispose();
                                    this.startAppInterstitialAd = null;
                                  },
                                  onAdClicked: () {
                                    isLoadingIo = false;
                                    debugPrint('onAdClicked: interstitial');
                                  },
                                  onAdHidden: () {
                                     isLoadingIo = false;
                                    debugPrint('onAdHidden: interstitial');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectYourFav()));
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
                            }*/ else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectYourFav()));
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SorryScreen()));
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(10),
                            child: Image.asset(_videoCallerList[index])),
                      );
                    },
                    itemCount: _videoCallerList.length,
                  ),
                )
              ],
            )),
        bottomNavigationBar: Container(
            alignment: Alignment.center,
            height: 75,
            color: Colors.white,

            child: _isLoaded != false && adType == "1"? SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ) : adType == "2" ? _facebookBannerAd : SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),)
        ),      ),
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
              ad.dispose();
              isAdLoading = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectYourFav()));
            },
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectYourFav()));

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
          isAdLoading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectYourFav()));
        },
      ),
    );
  }

  /// facebook Banner ad

  Widget _facebookBannerAd = SizedBox(width: 0, height: 0);

  void loadBannerAd() {
    setState(() {
      _facebookBannerAd = FacebookBannerAd(
        placementId: facebookBannerAdId,
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("$result == $value");
        },
      );
    });
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

  void _loadInterstitialAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: FacebookInterstailAdId,
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.ERROR && isButtonTapped == true) {
          setState(() {
            _loadAdInterstial();
            isButtonTapped = false;
          });
        }
        if (result == InterstitialAdResult.LOADED)
          isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED) {
          isInterstitialAdLoaded = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectYourFav()));

          _loadInterstitialAds();
        }
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

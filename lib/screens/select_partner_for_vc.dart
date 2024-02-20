import 'dart:io';

import 'package:Santa_prank_call/screens/attendcall_screen.dart';
import 'package:Santa_prank_call/screens/select_country.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SelectYourFav extends StatefulWidget {
  const SelectYourFav({Key? key}) : super(key: key);

  @override
  State<SelectYourFav> createState() => _SelectYourFavState();
}

class _SelectYourFavState extends State<SelectYourFav>
    with WidgetsBindingObserver {
  late BannerAd _bannerAd;
  bool isInterstitialAdLoaded = false;

  // StartAppInterstitialAd? startAppInterstitialAd;
  // var startAppSdk = StartAppSdk();
  // StartAppBannerAd? startAppBannerAd;
  // StartAppBannerAd? mrecAd;
  bool isAdLoading = false;
  bool isAdLoaded = false;
  bool isButtonTapped = false;
  final List<String> _videoCallerUSerList = [
    "assets/sant1.png",
    "assets/sant2.png",
    "assets/sant3.png",
    "assets/sant4.png",
    "assets/sant5.png"
  ];
  final int _tapCounter = 0;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  bool isLoadingIo = false;

  int maxFailedLoadAttempts = 3;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool facebookBannerAdError = false;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _loadBannerAd();

    // TODO: implement initState
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);


    if (adType == "2") {
      loadFacebookBannerAd();
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

    // facebookBannerAd = FacebookBannerAd(
    //   placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
    //   bannerSize: BannerSize.STANDARD,
    //   listener: (p0, p1) {
    //
    //   },
    // );

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    // _rewardedInterstitialAd?.dispose();
  }

  // FacebookBannerAd? facebookBannerAd;
  // RewardedInterstitialAd? _rewardedInterstitialAd;
  final int _numRewardedInterstitialLoadAttempts = 0;
  InterstitialAd? interstitialAd;
  int? selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                  color: PinkColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(100)),
                ),
                child: Text(
                  "Choose your Favourite\nfor video call",
                  style: TextStyle(
                      fontSize: 27,
                      color: textcolor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        isButtonTapped = true;
                        if (adType == "1") {
                          if (!isAdLoading) {
                            _loadAdInterstial(index);
                          }
                        } else if (adType == "2") {
                          _loadInterstitialAds();
                          FacebookInterstitialAd.showInterstitialAd();
                        }
                        /*else if (adType == "3" && !isLoadingIo) {
                  try {
                    isLoadingIo = true;
                    await startAppSdk
                        .loadInterstitialAd(
                      prefs: const StartAppAdPreferences(
                          adTag: 'home_screen'),
                      onAdDisplayed: () {
                        debugPrint('onAdDisplayed: interstitial');
                      },
                      onAdNotDisplayed: () {
                        isLoadingIo = false;
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

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
                              indexnumber: index,
                            )));
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
                        "Error loading or showing Interstitial ad: ${ex
                            .message}");
                  } catch (error, stackTrace) {
                    debugPrint(
                        "Error loading or showing Interstitial ad: $error");
                  }
                }*/
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendCallScreenForVc(
                                        indexnumber: index,
                                      )));
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(_videoCallerUSerList[index])),
                          Positioned(
                              top: 50,
                              right: 40,
                              child: Image.asset(
                                "assets/camera_ic.png",
                                width: 40,
                                height: 40,
                              )),
                        ],
                      ),
                    );
                  },
                  itemCount: _videoCallerUSerList.length,
                ),
              )
            ])),

        /// facebook Banner ad

        bottomNavigationBar: Container(
          alignment: Alignment.center,
          height:  (_isBannerAdReady) ? _bannerAd.size.height.toDouble() : 75,
          width: MediaQuery.of(context).size.width,
          child:  (_isBannerAdReady) ?
          Container(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          )
              : (adType == "2")
              ? (facebookBannerAdError == true && _isBannerAdReady != false
              ? SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          )
              : _facebookBannerAd )
              : const SizedBox(),
        )
    );
  }

  /// google Banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
          debugPrint('BannerAd failed to load: $err');
        },
      ),
    );

    _bannerAd.load();
  }

  /// facebook Banner ad

  Widget _facebookBannerAd = const SizedBox(width: 0, height: 0);

  void loadFacebookBannerAd() {
    setState(() {
      _facebookBannerAd = FacebookBannerAd(
        placementId: facebookBannerAdId,
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("$result == $value");

          if (result == BannerAdResult.ERROR) {
            setState(() {
              facebookBannerAdError = true;
            });
          }
        },
      );
    });
  }

  void _loadAdInterstial(int index) {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendCallScreenForVc(
                            indexnumber: index,
                          )));
            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendCallScreenForVc(
                              indexnumber: index,
                            )));
                ad.dispose();
                isAdLoading = false;
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendCallScreenForVc(
                        indexnumber: index,
                      )));
        },
      ),
    );
  }

  void _loadInterstitialAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: FacebookInterstailAdId,
      listener: (result, value) {
        if (result == InterstitialAdResult.ERROR && isButtonTapped == true) {
          setState(() {
            _loadAdInterstial(0);
            isButtonTapped = false;
          });
        }
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED) {
          isInterstitialAdLoaded = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AttendCallScreenForVc()));
          _loadInterstitialAds();
        }
      },
    );
  }
}

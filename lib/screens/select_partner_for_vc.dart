import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/attendcall_screen.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/ads.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

class SelectYourFav extends StatefulWidget {
  const SelectYourFav({Key? key}) : super(key: key);

  @override
  State<SelectYourFav> createState() => _SelectYourFavState();
}

class _SelectYourFavState extends State<SelectYourFav> with WidgetsBindingObserver{
  late BannerAd _bannerAd;
  bool isInterstitialAdLoaded = false;
  StartAppInterstitialAd? startAppInterstitialAd;
  var startAppSdk = StartAppSdk();
  StartAppBannerAd? startAppBannerAd;
  StartAppBannerAd? mrecAd;
  bool isAdLoading = false;
  bool isAdLoaded = false;
  bool isButtonTapped = false;
  List<String> _videoCallerUSerList = [
    "assets/sant1.png",
    "assets/sant2.png",
    "assets/sant3.png",
    "assets/sant4.png",
    "assets/sant5.png"
  ];
  int _tapCounter = 0;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  bool isLoadingIo = false;

  final String adUnitId = Platform.isAndroid
      ? getStorage.read("BannerAdId")
      : 'ca-app-pub-3940256099942544/2934735716';
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
          ad.dispose();
        },
      ),
    )..load();
  }
  @override
  void initState() {
    // TODO: implement initState
    loadAd();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);

    // _createRewardedInterstitialAd();
    if(adType == "2"){
      loadBannerAd();
    }
    if(adType == "2"){
      _loadInterstitialAds();
    }
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
  int _numRewardedInterstitialLoadAttempts = 0;
  InterstitialAd? interstitialAd;
  int? selectedCategoryIndex;
  //
  // void _createRewardedInterstitialAd() {
  //   RewardedInterstitialAd.load(
  //       adUnitId: AdHelper.rewardedInterstitialAd,
  //       request: AdRequest(),
  //       rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
  //         onAdLoaded: (RewardedInterstitialAd ad) {
  //           print('$ad loaded.');
  //           _rewardedInterstitialAd = ad;
  //           _numRewardedInterstitialLoadAttempts = 0;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('RewardedInterstitialAd failed to load: $error');
  //           _rewardedInterstitialAd = null;
  //           _numRewardedInterstitialLoadAttempts += 1;
  //           if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
  //             _createRewardedInterstitialAd();
  //           }
  //         },
  //       ));
  // }
  //
  // void _showRewardedInterstitialAd() {
  //   if (_rewardedInterstitialAd == null) {
  //     print('Warning: attempt to show rewarded interstitial before loaded.');
  //     return;
  //   }
  //   _rewardedInterstitialAd!.fullScreenContentCallback =
  //       FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
  //         print('$ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //
  //       ad.dispose();
  //
  //       _createRewardedInterstitialAd();
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => AttendCallScreenForVc()));
  //     },
  //     onAdFailedToShowFullScreenContent:
  //         (RewardedInterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createRewardedInterstitialAd();
  //     },
  //   );
  //
  //   _rewardedInterstitialAd!.setImmersiveMode(true);
  //   _rewardedInterstitialAd!.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
  //     print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
  //   });
  //   _rewardedInterstitialAd = null;
  // }

  // void loadInterstitial() {
  //   InterstitialAd.load(
  //     adUnitId: "ca-app-pub-3940256099942544/1033173712",
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         print("Ad Loaded");
  //         setState(() {
  //           interstitialAd = ad;
  //           isInterstitialAdLoaded = true;
  //           _showInterstitialAd();
  //         });
  //       },
  //       onAdFailedToLoad: (error) {
  //         print("Ad Failed to Load");
  //       },
  //     ),
  //   );
  // }
  //
  // void _showInterstitialAd() {
  //   if (interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdWillDismissFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => AttendCallscreen()));
  //     },
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => AttendCallscreen()));
  //       print('$ad onAdDismissedFullScreenContent.');
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       Navigator.pop(context);
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //     },
  //   );
  //   interstitialAd!.show();
  //   interstitialAd = null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                color: PinkColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100)),
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
                    onTap: () async{
                    isButtonTapped = true;
                    if (adType == "1") {
                      if (!isAdLoading) {
                        _loadAdInterstial(index);
                      }
                    } else if (adType == "2") {
                      _loadInterstitialAds();
                      FacebookInterstitialAd.showInterstitialAd();
                    } else if (adType == "3" && !isLoadingIo) {
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
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
                            indexnumber: index,
                          )));
                    }


                    },
                    child: Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(10),
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
        height: 75,
        color: Colors.black12,

        child: _isLoaded != false && adType == "1"? SizedBox(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bannerAd),
        ) : (adType == "3" && mrecAd != null)  ? StartAppBanner(mrecAd!) : _facebookBannerAd,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
                      indexnumber: index,
                    )));

            },
            onAdDismissedFullScreenContent: (ad) {

              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
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
        if(result == InterstitialAdResult.ERROR && isButtonTapped == true){
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
        if (result == InterstitialAdResult.DISMISSED ) {
          isInterstitialAdLoaded = false;
         Navigator.push(context,
             MaterialPageRoute(builder: (context) => AttendCallScreenForVc()));
          _loadInterstitialAds();
        }
      },
    );
  }
}

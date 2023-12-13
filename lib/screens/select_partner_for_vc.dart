import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/attend_call.dart';
import 'package:Santa_prank_call/screens/attendcall_screen.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/ads.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
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
  late BannerAd bannerAd;
  bool isInterstitialAdLoaded = false;
  StartAppInterstitialAd? startAppInterstitialAd;
  var startAppSdk = StartAppSdk();
  StartAppBannerAd? startAppBannerAd;
  StartAppBannerAd? mrecAd;
  bool isAdLoading = false;
  bool isAdLoaded = false;
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
  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        }),
        request: AdRequest());
  }

  var adUnit = getStorage.read("BannerAdId");
  int maxFailedLoadAttempts = 3;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  @override
  void initState() {
    // TODO: implement initState
    initBannerAd();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    _loadInterstitialAds();
    // _createRewardedInterstitialAd();
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

    // facebookBannerAd = FacebookBannerAd(
    //   placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
    //   bannerSize: BannerSize.STANDARD,
    //   listener: (p0, p1) {
    //
    //   },
    // );
    bannerAd.load();
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
                        //         Navigator.push(context,
                        //             MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
                        //               indexnumber: index,
                        //             )));
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
                        //     _loadAdInterstial(index);
                        //   }
                        // }

                      // _showRewardedInterstitialAd();
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
      bottomNavigationBar:(adType == "1" && mrecAd != null)
          ? SizedBox(
          height: bannerAd.size.height.toDouble(),
          width: bannerAd.size.width.toDouble(),
          child:StartAppBanner(mrecAd!) )
          :   isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: bannerAd,
              ),
            )
          : SizedBox(),
    );
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
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AttendCallScreenForVc(
                      indexnumber: index,
                    )));
              });
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
      placementId: "IMG_16_9_APP_INSTALL#1077658573437041_1077659113436987",
      listener: (result, value) {
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

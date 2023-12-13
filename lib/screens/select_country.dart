import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

import 'terms_condition.dart';



class SelectCountriescreen extends StatefulWidget {
  const SelectCountriescreen({Key? key}) : super(key: key);

  @override
  State<SelectCountriescreen> createState() => _SelectCountriescreenState();
}

class _SelectCountriescreenState extends State<SelectCountriescreen> with WidgetsBindingObserver{
  BannerAd? _bannerAd;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool isInterstitialAdLoaded = false;
  StartAppBannerAd? bannerAd;
  StartAppBannerAd? mrecAd;
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? startAppInterstitialAd;




  InterstitialAd? _interstitialAd;
  int _tapCounter = 0;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  final String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  bool isAdLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAds();
    startAppSdk.setTestAdsEnabled(true);
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
    // Load the banner ad when the screen initializes
    loadBannerAd();

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
  }



  int _selectedImageIndex = -1; // Default value indicating no selection
  List<String> _text = [
    "Austria",
    "Brazil",
    "China",
    "Singapore",
    "India",
    "United kingdom",
    "Russia",
    "Japan",
    "France",
    "Portugal",
    "France",
  ];
  List<String> _CountrImageList = [
    "assets/ic_austria.png",
    "assets/ic_brazil.png",
    "assets/ic_china.png",
    "assets/ic_singapore.png",
    "assets/ic_india.png",
    "assets/download.png",
    "assets/download (1).png",
    "assets/download (2).png",
    "assets/download (3).png",
    "assets/download (4).png",
    "assets/download (5).png"
  ];

  Future<void> loadBannerAd() async {
    try {
      final bannerAd = await startAppSdk.loadBannerAd(
        StartAppBannerType.BANNER,
        prefs: const StartAppAdPreferences(adTag: 'primary'),
        onAdImpression: () {
          debugPrint('onAdImpression: banner');
        },
        onAdClicked: () {
          debugPrint('onAdClicked: banner');
        },
      );

      setState(() {
        this.bannerAd = bannerAd;
      });
    } on StartAppException catch (ex) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    } catch (error) {
      debugPrint("Error loading Banner ad: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(minimumSize: MaterialStateProperty.all(Size(224, 36)));

    return Scaffold(
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
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
              ),
              child: Text(
                "Select the Country",
                style: TextStyle(
                    fontSize: 27,
                    color: textcolor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.78,
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.68
                      ),
                      itemCount: _text.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
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
                            //         Navigator.push(context,
                            //             MaterialPageRoute(builder: (context) => SeletctCategerioesScreen()));
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
                          child: GridTile(
                            child: Container(
                              padding: EdgeInsets.all(17),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                              ),
                              child: Column(
                                children: [

                                  ClipOval(
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      _CountrImageList[index],
                                      width: 70.0,
                                      height: 70.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    _text[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Display the banner if it is not null
            //  ( adType == "1") ? StartAppBanner(bannerAd!) : SizedBox(),
            /*bannerAd != null
                ? StartAppBanner(bannerAd!)
                : ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                startAppSdk.loadBannerAd(
                  StartAppBannerType.BANNER,
                  prefs: const StartAppAdPreferences(adTag: 'primary'),
                  onAdImpression: () {
                    debugPrint('onAdImpression: banner');
                  },
                  onAdClicked: () {
                    debugPrint('onAdClicked: banner');
                  },
                ).then((bannerAd) {
                  setState(() {
                    this.bannerAd = bannerAd;
                  });
                }).onError<StartAppException>((ex, stackTrace) {
                  debugPrint("Error loading Banner ad: ${ex.message}");
                }).onError((error, stackTrace) {
                  debugPrint("Error loading Banner ad: $error");
                });
              },
              child: Text('Show Banner'),
            ),*/
          ],
        ),
      ),
    );
  }
  void _loadAd() async {
    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
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
            },
            onAdDismissedFullScreenContent: (ad) {

              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeletctCategerioesScreen()));
                ad.dispose();
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
          print('InterstitialAd failed to load: $error');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SeletctCategerioesScreen()));
          isAdLoading = false;
        },
      ),
    );
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SeletctCategerioesScreen()));


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

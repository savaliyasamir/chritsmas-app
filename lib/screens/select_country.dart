import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'terms_condition.dart';

String adUnitId ="ca-app-pub-3940256099942544/6300978111";


class SelectCountriescreen extends StatefulWidget {
  const SelectCountriescreen({Key? key}) : super(key: key);

  @override
  State<SelectCountriescreen> createState() => _SelectCountriescreenState();
}

class _SelectCountriescreenState extends State<SelectCountriescreen>
    with WidgetsBindingObserver {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool isInterstitialAdLoaded = false;
  // StartAppBannerAd? bannerAd;
  // StartAppBannerAd? mrecAd;
  // var startAppSdk = StartAppSdk();
  bool isButtonTapped = false;
  // StartAppInterstitialAd? startAppInterstitialAd;
  bool isLoadingIo = false;
  InterstitialAd? _interstitialAd;
  int _tapCounter = 0;
  final String _adUnitId = Platform.isAndroid
      ? InterstialAdID
      : 'ca-app-pub-3940256099942544/4411468910';
  bool isAdLoading = false;
  bool _isLoaded = false;
  bool facebookBannerAdError = false;


  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);


      _loadBannerAd();




    if (adType == "2") {
      loadFacebookBannerAd();
    }
    // if (adType == "3") {
    //   startAppSdk
    //       .loadBannerAd(
    //     StartAppBannerType.MREC,
    //     prefs: const StartAppAdPreferences(adTag: 'secondary'),
    //   )
    //       .then((mrecAd) {
    //     setState(() {
    //       this.mrecAd = mrecAd;
    //     });
    //   }).onError<StartAppException>((ex, stackTrace) {
    //     debugPrint("Error loading Mrec ad: ${ex.message}");
    //   }).onError((error, stackTrace) {
    //     debugPrint("Error loading Mrec ad: $error");
    //   });
    // }
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

  // Future<void> loadBannerAd() async {
  //   try {
  //     final bannerAd = await startAppSdk.loadBannerAd(
  //       StartAppBannerType.BANNER,
  //       prefs: const StartAppAdPreferences(adTag: 'primary'),
  //       onAdImpression: () {
  //         debugPrint('onAdImpression: banner');
  //       },
  //       onAdClicked: () {
  //         debugPrint('onAdClicked: banner');
  //       },
  //     );
  //
  //     setState(() {
  //       this.bannerAd = bannerAd;
  //     });
  //   } on StartAppException catch (ex) {
  //     debugPrint("Error loading Banner ad: ${ex.message}");
  //   } catch (error) {
  //     debugPrint("Error loading Banner ad: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                            childAspectRatio: 0.68),
                        itemCount: _text.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              isButtonTapped = true;
                              if (adType == "1") {
                                if (!isAdLoading) {
                                  _loadAdInterstial();
                                }
                              } else if(adType == "2"){
                                _loadInterstitialAds();
                                FacebookInterstitialAd.showInterstitialAd();
                              } /*else if (adType == "3" &&   !isLoadingIo){
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

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SeletctCategerioesScreen()));
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
                              }*/ else{
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SeletctCategerioesScreen()));
                              }
                            },
                            child: GridTile(
                              child: Container(
                                padding: EdgeInsets.all(17),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
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
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: (_isBannerAdReady) ? _bannerAd.size.height.toDouble() : 75,
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
            : SizedBox(),
      )
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

            },
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeletctCategerioesScreen()));
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SeletctCategerioesScreen()));
          isAdLoading = false;
        },
      ),
    );
  }
  /// google Banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: AdRequest(),
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
        },
      ),
    );

    _bannerAd.load();
  }


  /// facebook Banner ad

  Widget _facebookBannerAd = SizedBox(width: 0, height: 0);

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _loadInterstitialAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: FacebookInterstailAdId,
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if(result == InterstitialAdResult.ERROR && isButtonTapped == true){
         setState(() {
           _loadAdInterstial();
           isButtonTapped = false;
         });
        }
        if (result == InterstitialAdResult.DISMISSED) {
          isInterstitialAdLoaded = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SeletctCategerioesScreen()));

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

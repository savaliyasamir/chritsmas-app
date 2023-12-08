import 'dart:io';

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/SorryScreen.dart';
import 'package:Santa_prank_call/screens/select_partner_for_vc.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  bool isAdLoading = false;
  List<String> _videoCallerList = [
    "assets/ic_santa.png",
    "assets/ic_cricket.png",
    "assets/ic_football.png",
    "assets/ic_singer.png",
    "assets/ic_influencer.png"
  ];
  BannerAd? _bannerAd;

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

  @override
  void initState() {
    super.initState();
    // _createRewardedInterstitialAd();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
  }

  InterstitialAd? interstitialAd;
  bool isInterstitialAdLoaded = false;

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
                        onTap: () {
                          if(index == 0){
                            if(!isAdLoading )
                            {
                              _loadAdInterstial();
                            }
                          }

                              else {
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
          height: 60,
          color: Colors.black12,
          child: _bannerAd != null
              ? SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
              : SizedBox(),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectYourFav()));
            },
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectYourFav()));

              setState(() {
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
          isAdLoading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectYourFav()));
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
    _bannerAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

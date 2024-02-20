// ignore_for_file: avoid_print, non_constant_identifier_names, sized_box_for_whitespace

import 'package:Santa_prank_call/main.dart';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helpers/ad_helper.dart';
import 'terms_condition.dart';

String adUnitId = getStorage.read("BannerAdId");

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
  }

  final List<String> _text = [
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
  final List<String> _CountrImageList = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                  color: PinkColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(100)),
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
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.78,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 0.68,
                            ),
                        itemCount: _text.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (adType == "1") {
                                AdHelper.showInterstitialAd(
                                  onComplete: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SeletctCategerioesScreen()));                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SeletctCategerioesScreen()));                              }
                            },
                            child: GridTile(
                              child: Container(
                                padding: const EdgeInsets.all(17),
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
                                    const SizedBox(height: 8.0),
                                    Text(
                                      _text[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: (_isBannerAdReady) ? _bannerAd.size.height.toDouble() : 75,
        width: MediaQuery.of(context).size.width,
        child: (_isBannerAdReady)
            ? Container(
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
                    : _facebookBannerAd)
                : const SizedBox(),
      ),
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

  @override
  void dispose() {
    _bannerAd.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

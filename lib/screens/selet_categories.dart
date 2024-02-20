// ignore_for_file: no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, avoid_print

import 'package:Santa_prank_call/screens/SorryScreen.dart';
import 'package:Santa_prank_call/screens/select_country.dart';
import 'package:Santa_prank_call/screens/terms_condition.dart';
import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helpers/ad_helper.dart';
import '../widget/constant.dart';

class SeletctCategerioesScreen extends StatefulWidget {
  const SeletctCategerioesScreen({Key? key}) : super(key: key);

  @override
  State<SeletctCategerioesScreen> createState() =>
      _SeletctCategerioesScreenState();
}

class _SeletctCategerioesScreenState extends State<SeletctCategerioesScreen>
    with WidgetsBindingObserver {

  bool facebookBannerAdError = false;
  final List<String> _videoCallerList = [
    "assets/ic_santa.png",
    "assets/ic_cricket.png",
    "assets/ic_football.png",
    "assets/ic_singer.png",
    "assets/ic_influencer.png"
  ];
  late BannerAd _bannerAd;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);

    /// Loads a banner ad.
    _loadBannerAd();
    if (adType == "2") {
      loadFacebookBannerAd();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
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
                itemCount: _videoCallerList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (adType == "1") {
                        AdHelper.showInterstitialAd(
                          onComplete: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SorryScreen()));                          },
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SorryScreen()));                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(_videoCallerList[index])),
                  );
                },
              ),
            )
          ],
        )),
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
                : const SizedBox(),
          )
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

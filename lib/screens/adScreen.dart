import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    FacebookAudienceNetwork.init();
    super.initState();
  }

  showInter() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "1077658573437041_1077659113436987",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 2
          );
        if( result == InterstitialAdResult.LOADED)
          print("not showing");
      },
    );
  }

  Widget _bannerAd = SizedBox(width: 0, height: 0);

  void loadBannerAd() {
    setState(() {
      _bannerAd = FacebookBannerAd(
        placementId: "IMG_16_9_APP_INSTALL#1077658573437041_1077659073436991",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("$result == $value");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facebook Audience Network")),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Load Banner Ad"),
            onPressed: () => loadBannerAd(),
          ),
          Text("Facebook Audience Network Testing"),
          ElevatedButton(
            onPressed: () {
              showInter();
            },
            child: Text("Show Interstitial Ad"),
          ),
          ElevatedButton(onPressed:
          _showNativeAd, child: Text("Native Ad")),
          ElevatedButton(onPressed:
          _showNativeBannerAd, child: Text("Native Banner Ad")),
          _currentAd,
          _currentFacebookNativeAd,
          Flexible(
            child: Container(),
            flex: 1,
            fit: FlexFit.tight,
          ),
          _bannerAd
        ],
      ),
    );
  }

  Widget _currentFacebookNativeAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  _showNativeBannerAd() {
    setState(() {
      _currentAd = _nativeBannerAd();
    });
  }

  Widget _nativeBannerAd() {
    return FacebookNativeAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Banner Ad: $result --> $value");
      },
    );
  }


  _showNativeAd() {
    setState(() {
      _currentFacebookNativeAd = _facebookNativeAd();
    });
  }

  Widget _facebookNativeAd() {
    return FacebookNativeAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }
}

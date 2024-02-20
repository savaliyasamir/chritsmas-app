import '../main.dart';

class Config {
  //ad ids
  static String get nativeAd => "/21753324030,23062064445/com.monjila.christmasapp_Native";
  static String get interstitialAd => getStorage.read("InterStialAdId");
  static bool get hideAds => false;
}
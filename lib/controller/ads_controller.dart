// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyController extends GetxController {
  NativeAd? nativeAd;
  NativeAd? onBoardinmgScreen1;
  NativeAd? searchScreenNaAd;
  NativeAd? shareAppNaAd;
  NativeAd? contactUsNaAd;
  RxBool iscontactUseAdLoaded = false.obs;
  RxBool isShareAppAdLoaded = false.obs;
  RxBool isSearchScreenAdLoaded = false.obs;
  RxBool isAdLoaded = false.obs;
  NativeAd? jobDetailScreenNaAd;
  RxBool isJobDetailScreenAdLoaded = false.obs;
  RxBool isOnBoadScreenAdLoaded = false.obs;
  NativeAd? privacyPolicyNaAd;
  NativeAd? jobListNaAd;
  NativeAd? jobList2;
  RxBool isJobList2isLoaded = false.obs;
  RxBool isJobListAdLoaded = false.obs;
  RxBool isPrvicayAdLoaded = false.obs;
  final String adUnitId =
      "/22475853447,22943943935/aercal_com.easy.easy_emi_calculator_nativeadvanced";
  NativeAd? logInNativeAd;
  NativeAd? drawerScreenNativeAd;
  RxBool isDrawerNativedLoaded = false.obs;

  onBoardingscreenLoadAd() {
    onBoardinmgScreen1 = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isOnBoadScreenAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isOnBoadScreenAdLoaded.value = false;
            onBoardingscreenLoadAd();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    onBoardinmgScreen1!.load();
  }

  jobDetailScreenNative() {
    jobDetailScreenNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isJobDetailScreenAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isJobDetailScreenAdLoaded.value = false;
            jobDetailScreenNative();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    jobDetailScreenNaAd!.load();
  }

  loadAd() {
    nativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isAdLoaded.value = false;
            privacyPolicyScreenNative();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    nativeAd!.load();
  }

  ///LogInScreen:
  SearchScreenNativeAd() {
    searchScreenNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isSearchScreenAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isSearchScreenAdLoaded.value = false;
            SearchScreenNativeAd();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    searchScreenNaAd!.load();
  }

  ///Drawer Screen (Rate App):
  drawerscreenNativeAd() {
    drawerScreenNativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isDrawerNativedLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isDrawerNativedLoaded.value = false;
            drawerscreenNativeAd();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    drawerScreenNativeAd!.load();
  }

  ///Drawer Screen (Share App):
  shareAppScreenNative() {
    shareAppNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isShareAppAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isShareAppAdLoaded.value = false;
            shareAppScreenNative();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    shareAppNaAd!.load();
  }

  ///Drawer Screen (Contact Us):
  contactUsScreenNative() {
    contactUsNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            iscontactUseAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            iscontactUseAdLoaded.value = false;
            contactUsScreenNative();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    contactUsNaAd!.load();
  }

  ///Drawer Screen (Privacy Policy):

  privacyPolicyScreenNative() {
    privacyPolicyNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isPrvicayAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isPrvicayAdLoaded.value = false;
            privacyPolicyScreenNative();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    privacyPolicyNaAd!.load();
  }

  ///Job List:
  jobListNativeAd() {
    jobListNaAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isJobListAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isJobListAdLoaded.value = false;
            jobListNativeAd();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    jobListNaAd!.load();
  }

  ///jobList 2:
  jobListNative2Ad() {
    jobList2 = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isJobList2isLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isJobList2isLoaded.value = false;
            jobListNative2Ad();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium));
    jobList2!.load();
  }

  jobListdisposeNAtiveAd() {
    if (jobListNaAd != null) {
      jobListNaAd!.dispose();
    }
  }

  jobListdisposeNAtive2Ad() {
    if (jobList2 != null) {
      jobList2!.dispose();
    }
  }

  disposeNAtiveAd() {
    if (nativeAd != null) {
      nativeAd!.dispose();
    }
  }

  contactUsdisposeNAtiveAd() {
    if (contactUsNaAd != null) {
      contactUsNaAd!.dispose();
    }
  }

  OnBoardingdisposeNAtiveAd() {
    if (onBoardinmgScreen1 != null) {
      onBoardinmgScreen1!.dispose();
    }
  }

  SearchScreenDisposeNAtiveAd() {
    if (searchScreenNaAd != null) {
      searchScreenNaAd!.dispose();
    }
  }

  drawerScreendisposeNAtiveAd() {
    if (drawerScreenNativeAd != null) {
      drawerScreenNativeAd!.dispose();
    }
  }

  jobDetailScreendisposeNAtiveAd() {
    if (jobDetailScreenNaAd != null) {
      jobDetailScreenNaAd!.dispose();
    }
  }

  shareAppdisposeNAtiveAd() {
    if (shareAppNaAd != null) {
      shareAppNaAd!.dispose();
    }
  }

  privacyPolicydisposeNAtiveAd() {
    if (privacyPolicyNaAd != null) {
      privacyPolicyNaAd!.dispose();
    }
  }
}

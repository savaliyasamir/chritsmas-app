// ignore_for_file: avoid_print

import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:flutter/material.dart';

class SorryScreen extends StatefulWidget {
  const SorryScreen({Key? key}) : super(key: key);

  @override
  State<SorryScreen> createState() => _SorryScreenState();
}

class _SorryScreenState extends State<SorryScreen> with WidgetsBindingObserver{
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  @override
  void initState() {
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("We are updating soon..",
                style: TextStyle(color: textcolor, fontSize: 30)),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: PinkColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Return",
                style: TextStyle(
                    color: textcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

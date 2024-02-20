// ignore_for_file: sized_box_for_whitespace

import 'package:Santa_prank_call/screens/rating_screen.dart';
import 'package:flutter/material.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      // getStorage.read("isLogin") == true ?  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserForVideocallList())) :
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const RatingScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/exit_screen.png",fit: BoxFit.cover,)),
      ),
    );
  }
}

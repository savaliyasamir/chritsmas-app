import 'package:Santa_prank_call/widget/appOpenAdManager.dart';
import 'package:Santa_prank_call/widget/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class AttendCallScreenForVc extends StatefulWidget {
  int? indexnumber;

  AttendCallScreenForVc({Key? key, this.indexnumber}) : super(key: key);

  @override
  State<AttendCallScreenForVc> createState() => _AttendCallScreenForVcState();
}

class _AttendCallScreenForVcState extends State<AttendCallScreenForVc> with WidgetsBindingObserver{
  late AudioPlayer audioPlayer;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;
  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    audioPlayer = AudioPlayer();
    _loadAudio();
    audioPlayer.play();
    _vibrateFor30Seconds();
  }

  Future<void> _loadAudio() async {
    await audioPlayer.setAsset('assets/ringtone.mp3');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset("assets/vc_image_attend.png",
                    fit: BoxFit.cover),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      audioPlayer.dispose();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                    videoUrl: widget.indexnumber == 0
                                        ? "assets/sanat_vc1.mp4"
                                        : widget.indexnumber == 1
                                            ? "assets/santa_vc2.mp4"
                                            : widget.indexnumber == 2
                                                ? "assets/santa_vc3.mp4"
                                                : widget.indexnumber == 3
                                                    ? "assets/santa_vc4.mp4"
                                                    : "assets/sanat_vc1.mp4",
                                  )));
                    },
                    child: Image.asset(
                      "assets/attend_call.png",
                      height: 90,
                      width: 180,
                    ),
                  )),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/cut_call.png",
                      height: 90,
                      width: 180,
                    ),
                  )),
            ],
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
  Future<void> _vibrateFor30Seconds() async {
    // Check if the device supports vibration
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator != null && hasVibrator) {
      // Vibrate for 30 seconds
      Vibration.vibrate(duration: 350);
    } else {
      // Device doesn't support vibration
      print("Device doesn't support vibration.");
    }
  }
}

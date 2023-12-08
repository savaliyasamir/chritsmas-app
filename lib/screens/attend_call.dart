import 'dart:typed_data';

import 'package:Santa_prank_call/widget/video_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class AttendCallscreen extends StatefulWidget {
  const AttendCallscreen({Key? key}) : super(key: key);

  @override
  State<AttendCallscreen> createState() => _AttendCallscreenState();
}

class _AttendCallscreenState extends State<AttendCallscreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Center(
              child: Text("Incoming videocall from santa..",style: TextStyle(
                  color: Colors.white,
                  fontSize: 25
              )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            Container(
              alignment: AlignmentDirectional.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),

                  image: DecorationImage(image: AssetImage("assets/santa.png"),fit: BoxFit.cover)
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.call_end,color: Colors.red,size: 30),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    audioPlayer.dispose();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(
                      videoUrl: "assets/new_video.mp4",
                    )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.call_end,color: Colors.white,size: 30),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> _vibrateFor30Seconds() async {
    // Check if the device supports vibration
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator != null && hasVibrator) {
      // Vibrate for 30 seconds
      Vibration.vibrate(duration: 350 );
    } else {
      // Device doesn't support vibration
      print("Device doesn't support vibration.");
    }
  }
}

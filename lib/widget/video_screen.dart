import 'package:Santa_prank_call/screens/after_call_cut_screen.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  double _positionedLeft = 0.0;
  double _positionedTop = 0.0;
  double _maxLeft = 0.0;
  double _maxTop = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        _videoPlayerController.play();
        // _videoPlayerController.setLooping(true);
      });

    availableCameras().then((cameras) {
      // Find the front camera in the list of available cameras
      CameraDescription frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // Initialize the controller with the front camera
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.veryHigh,
      );

      // Initialize the controller future asynchronously.
      _initializeControllerFuture = _controller.initialize(); // Initialize _initializeControllerFuture here
    });
  }

/*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the size of the video player to set constraints
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _maxLeft = MediaQuery.of(context).size.width - 150;
        _maxTop = MediaQuery.of(context).size.height - 150;
      });
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(),
          Positioned(
            right:0 /*_positionedLeft.clamp(0.0, _maxLeft)*/,
            top:20 /*_positionedTop.clamp(0.0, _maxTop)*/,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _positionedLeft += details.delta.dx;
                  _positionedTop += details.delta.dy;
                });
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 150),
                width: 150,
                height: 240,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.4,
            bottom: 50,
            child: GestureDetector(
              onTap: () {
            setState(() {
              _videoPlayerController.dispose();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ThankYouScreen()), (route) => false);
            });
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.call_end,color: Colors.white,size: 30),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _controller.dispose();

    super.dispose();
  }
}

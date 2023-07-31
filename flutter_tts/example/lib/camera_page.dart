import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'Previewpage.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  late SharedPreferences prefs;
  final FlutterTts tts = FlutterTts();
  double a = 0;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    getInitDate();
  }

  getInitDate() async {
    prefs = await SharedPreferences.getInstance();
    a = prefs.getDouble('speed') ?? 0.7;
    tts.setSpeechRate(a);
    tts.speak("원하시는 의약품을 촬영해주세요");
  }


  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      await _cameraController.setFocusMode(FocusMode.locked);
      await _cameraController.setExposureMode(ExposureMode.locked);
      XFile picture = await _cameraController.takePicture();
      await _cameraController.setFocusMode(FocusMode.auto);
      await _cameraController.setExposureMode(ExposureMode.auto);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                picture: picture,
              )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            (_cameraController.value.isInitialized)
                ? CameraPreview(_cameraController)
                : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.black),
                  child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          icon: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons.switch_camera_solid,
                              color: Colors.white),
                          onPressed: () {
                            setState(
                                    () => _isRearCameraSelected = !_isRearCameraSelected);
                            initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                          },
                        )),
                    Expanded(
                        child: IconButton(
                          onPressed: takePicture,
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.circle, color: Colors.white),
                        )),
                    const Spacer(),
                  ]),
                )),
          ]),
        )),
        onWillPop: () async{
         return false;
       },
    );
  }
}
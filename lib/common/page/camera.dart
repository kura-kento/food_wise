import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../app.dart';
import '../layout/appbar.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController cameraController;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppBar(
            title: 'カメラ起動',
            leftButton: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: App.btn_color),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ),
          _cameraPreview(context),
          const SizedBox(height: 48),
          _button(context),
        ],
      ),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.length >= 0) {
      cameraController = CameraController(cameras.first, ResolutionPreset.max, enableAudio: false);
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          initialized = true;
        });
      });
    }
  }

  Widget _button(context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        color: Colors.white,
        onPressed: () async {
          XFile xFile = await cameraController.takePicture();
          //画像をパスに保存
          // App.saveImagePath(xFile);
          Navigator.of(context).pop(xFile);
        },
      ),
    );
  }

  Widget _cameraPreview(context) {
    if (initialized) {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRect(
          child: Transform.scale(
            scale: cameraController.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1 / cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
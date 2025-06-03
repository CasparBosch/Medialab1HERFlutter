import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  static String routeName = 'camera';
  static String routePath = '/camera';

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _isRearCameraSelected ? _cameras.first : _cameras.last,
      ResolutionPreset.high,
    );
    await _controller.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  void _switchCamera() async {
    setState(() => _isInitialized = false);
    _isRearCameraSelected = !_isRearCameraSelected;
    await _controller.dispose();
    await _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Camera'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _isInitialized
          ? Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(Icons.close, () => Navigator.of(context).pop()),
                Row(
                  children: [
                    _iconButton(Icons.flash_off, () => print('Flash')),
                    _iconButton(Icons.timer_outlined, () => print('Timer')),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconButton(Icons.photo_library, () => print('Gallery')),
                _captureButton(),
                _iconButton(Icons.flip_camera_ios, _switchCamera),
              ],
            ),
          )
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _captureButton() {
    return GestureDetector(
      onTap: () async {
        final picture = await _controller.takePicture();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto opgeslagen: ${picture.path}')),
        );
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

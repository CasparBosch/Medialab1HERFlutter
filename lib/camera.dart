import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  static String routeName = 'camera';
  static String routePath = '/camera';

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

// Stateful widget die camerafunctionaliteit toont
class _CameraWidgetState extends State<CameraWidget> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isRearCameraSelected = true;

  // Add pose estimator fields
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  List<dynamic>? _poseResults;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  // Load TFLite pose model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/posenet.tflite');
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      debugPrint('Failed to load model: $e');
    }
  }

  // Laad beschikbare camera’s en initialised de controller
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _isRearCameraSelected ? _cameras.first : _cameras.last,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.bgra8888, // Needed for image processing
    );
    await _controller.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
    // Start stream for pose detection if model is loaded
    if (_isModelLoaded) {
      _controller.startImageStream(_processCameraImage);
    }
  }

  // Wisselt tussen voor-/achtercamera
  void _switchCamera() async {
    setState(() => _isInitialized = false);
    _isRearCameraSelected = !_isRearCameraSelected;
    await _controller.dispose();
    await _initializeCamera();
  }

  // Process camera image and run pose estimation
  void _processCameraImage(CameraImage image) async {
    if (!_isModelLoaded || _interpreter == null) return;

    // Convert CameraImage to TensorImage (simplified, only works for BGRA)
    try {
      final img.Image convertedImage = img.Image.fromBytes(
        image.width,
        image.height,
        image.planes[0].bytes,
        format: img.Format.bgra,
      );
      final tensorImage = TensorImage.fromImage(convertedImage);

      // Prepare output buffer
      var outputShapes = _interpreter!.getOutputTensors().map((t) => t.shape).toList();
      var outputTypes = _interpreter!.getOutputTensors().map((t) => t.type).toList();
      var outputs = <int, Object>{};
      for (int i = 0; i < outputShapes.length; i++) {
        outputs[i] = TensorBuffer.createFixedSize(outputShapes[i], outputTypes[i]);
      }

      _interpreter!.runForMultipleInputs([tensorImage.buffer], outputs);

      setState(() {
        _poseResults = outputs.values.toList();
      });
    } catch (e) {
      debugPrint('Pose estimation error: $e');
    }
  }

  @override
  void dispose() {
    // Ruimt de cameracontroller op bij het sluiten van de widget
    _controller.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  // Bouwt de gebruikersinterface van de cameraweergave
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
      // Toont camerabeeld of laadindicator
      body: _isInitialized
          ? Stack(
        children: [
          CameraPreview(_controller),
          // Overlay pose results (for demonstration, just show as text)
          if (_poseResults != null)
            Positioned(
              top: 100,
              left: 16,
              child: Container(
                color: Colors.black54,
                child: Text(
                  'Pose detected!',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ),
          // Bovenste knoppenrij (sluiten, flits, timer)
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
          // Onderste knoppenrij (galerij, foto maken, camera wisselen)
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

  // Maakt een ronde knop met een icoon en actie
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

  // Maakt en toont de opnameknop voor foto's
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

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poc_tflite_and_qr/firebase_options.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraImage? cameraImage;
  late CameraController cameraController;
  String result = "";
  Barcode? barcode;
  BarcodeScanner? barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  initCamera() {
    cameraController = CameraController(cameras.last, ResolutionPreset.low);
    cameraController.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController.startImageStream((cameraImg) {
          final img = _processCameraImage(cameraImg);
          runModel(cameraImg);
          runQR(img);
        });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  InputImage _processCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras.last;
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return inputImage;
  }

  var isBussy = false;
  runQR(InputImage img) async {
    if (isBussy) {
      return;
    }
    if (barcodeScanner != null) {
      isBussy = true;
      var qrRecognitions = await barcodeScanner!.processImage(img);
      qrRecognitions.forEach((element) {
        setState(() {
          barcode = element;
          print(barcode);
        });
      });
      isBussy = false;
    }
  }

  var isTensorflowBussy = false;
  runModel(CameraImage img) async {
    if (isTensorflowBussy) {
      return;
    }
    // if (cameraImage != null) {
    isTensorflowBussy = true;
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((e) => e.bytes).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.3,
        asynch: true);
    isTensorflowBussy = false;
    recognitions?.forEach((element) {
      setState(() {
        result = element["label"];
        print(result);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  StreamController<ui.Image> streamImgBytes = StreamController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Face Mask Detector"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: MediaQuery.of(context).size.height - 170,
                  width: MediaQuery.of(context).size.width,
                  child: !cameraController.value.isInitialized
                      ? Container()
                      : AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                ),
              ),
            ),
            Container(child: Text('tensorflow lite face_mask: $result')),
            Container(
              child: Column(
                children: [
                  Text("Barcode"),
                  barcode != null
                      ? Column(
                          children: [
                            Text('Barcode type ${barcode!.type}'),
                            Text('data : ${barcode!.value.rawValue}')
                          ],
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

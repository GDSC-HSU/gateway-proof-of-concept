     // var recognitions = await Tflite.runModelOnFrame(
      //     bytesList: cameraImage!.planes.map((plane) {
      //       return plane.bytes;
      //     }).toList(),
      //     imageHeight: cameraImage!.height,
      //     imageWidth: cameraImage!.width,
      //     imageMean: 127.5,
      //     imageStd: 127.5,
      //     rotation: 90,
      //     numResults: 2,
      //     threshold: 0.3,
      //     asynch: true);
      // recognitions?.forEach((element) {
      //   setState(() {
      //     result = element["label"];
      //     print(result);
      //   });
      // });
import 'dart:io';
import 'package:firebase_ml_text_recognition/api/firebase_ml_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../scanned-result.dart';
import 'image-picker-widget.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = '';
  File image;
  PickedFile pickedFile;

  @override
  Widget build(BuildContext context) => Stack(children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical:18.0,horizontal: 18.0),
              child: LayoutBuilder(
                  builder: (_, constraints) => Container(
                      width: constraints.widthConstraints().maxWidth,
                      height: constraints.widthConstraints().maxHeight,
                      child: CustomPaint(
                        painter: FaceOutlinepainter(),
                      ))),
            ),
            // Expanded(child: buildImage()),
            // const SizedBox(height: 16),




            Padding(
              padding: const EdgeInsets.symmetric(horizontal:50.0,vertical: 50.0),
              child: ImagePickerWidget(
                image: image.toString(),
                onImagePicked: (PickedFile file) {
                  pickedFile = file;
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),

            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.88,
            //   height: MediaQuery.of(context).size.height * 0.08,
            //   child: RaisedButton(
            //     textColor: Colors.white,
            //     elevation: 0.0,
            //     color: Colors.deepOrange,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(18.0),
            //         side: BorderSide(color: Colors.red)),
            //     onPressed: () {
            //       scanText();
            //     },
            //     child: Text('Scan For Text'),
            //   ),
            // ),

            // ControlsWidget(
            //    // onClickedPickImage: pickImage,
            //   onClickedScanText: scanText,
            //   onClickedClear: clear,
            // ),
            const SizedBox(height: 16),


      ]

  );

  //
  // Widget buildImage() => Container(
  //       child: image != null
  //           ? Image.file(image)
  //           : Icon(Icons.photo, size: 80, color: Colors.black),
  //     );

  // Future pickImage() async {
  //   final file = await ImagePicker().getImage(source: ImageSource.gallery);
  //   setImage(File(file.path));
  // }

  Future scanText() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    final text = await FirebaseMLApi.recogniseText(File(pickedFile.path));
    setText(text);

    Navigator.of(context).pop();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScannedResult(scannedResult: text)));
  }

  void clear() {
    setImage(null);
    setText('');
  }

  // void copyToClipboard() {
  //   if (text.trim() != '') {
  //     FlutterClipboard.copy(text);
  //   }
  // }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }
}


class FaceOutlinepainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.deepOrange;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;

    var path = Path();

    var startingPoint = Offset(size.width, size.height);
    var endingPoint = Offset(size.width, size.height / 2);

    // canvas.drawLine(startingPoint, endingPoint, paint);
    // canvas.drawCircle(startingPoint, 100, paint);
    // path.quadraticBezierTo(0,size.height/5, size.width/3,size.height);
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(0, 0, size.width, size.height),
            Radius.circular(30.0)),
        paint);

    // path.lineTo(0, size.height);

    //
    // path.lineTo(size.width, size.height);
    //  path.lineTo(size.width, 0);
    //
    // path.lineTo(0, 0);
    //
    // // path.moveTo(0, size.height/2);
    // // path.lineTo(size.width, size.height/2);
    // canvas.drawPath(path, paint);

    path.moveTo(size.width / 14, 0);
    path.lineTo(size.width / 14, size.height / 1.08);
    path.lineTo(size.width, size.height / 1.08);

    canvas.drawPath(path, paint);

    path.moveTo(size.width / 14, 0);
    path.lineTo(size.width / 14, size.height / 1.08);
    path.lineTo(size.width - 320, size.height-19);

    canvas.drawPath(path, paint);

//     final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);
//
//     path.quadraticBezierTo(0, 50, 50, 10);
// //2
// //3
//     canvas.drawRect(shapeBounds, paintt);

    // path.lineTo(0, size.height);
    // path.quadraticBezierTo(size.width, size.height-50,   size.width, size.height);
    // path.lineTo(size.width, size.height);
    //  path.lineTo(size.width, 0);
    //  path.lineTo(0, 0);

    //  SizedBox(height: 10,width: 10.0);
    // path.lineTo( 100, size.height);
    // // path.quadraticBezierTo(size.width, size.height-50,   size.width, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);

    // path.lineTo(size.width, size.height);
    //
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);

    // path.lineTo(size.width, size.height);
    // path.quadraticBezierTo(
    //     size.width / 2, size.height / 2, size.width, size.height * 0.25);

    // canvas.drawPath(path, paintt);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

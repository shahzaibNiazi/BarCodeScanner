import 'dart:io';

import 'package:firebase_ml_text_recognition/api/firebase_ml_api.dart';
import 'package:firebase_ml_text_recognition/utils/custom-navigator.dart';
import 'package:firebase_ml_text_recognition/widget/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'book-recommendator.dart';
import 'custom-clipper.dart';
import 'scanned-result.dart';

class AppHomePage extends StatefulWidget {
  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {

  Color firstColor = Color(0xFFF47D15);
  Color secondColor = Color(0xFFEF772C);
  PickedFile _image;
  final key = GlobalKey<ScaffoldState>();


  void scanImage(PickedFile file) async {
    openLoadingDialog(context, "Scanning");
    String recognizedText = await FirebaseMLApi.recogniseText(File(file.path));
    Navigator.pop(context);
    if(recognizedText != 'No text found in the image')
      navigateTo(context, ScannedResult(scannedResult: recognizedText,));
    else
      key.currentState.showSnackBar(
          SnackBar(content: Text("No text found in the image."),
            behavior: SnackBarBehavior.floating,));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var fontSize = height /33;
    var imageScale = height /40;
    print(height);
    print(imageScale);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  Color(0xFFF47D15),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.book),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("Book Scanner"),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
             height: height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [firstColor, secondColor],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // SizedBox(height: height * 0.05,),
                Container(
                  height: height*0.1,
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Text("Start Scanning",style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ),
               // SizedBox(height: height * 0.05,),
                Container(
                  height: height*0.3,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(

                        children: [
                          GestureDetector(
                            onTap:() async{
                                final image = await ImagePicker()
                                    .getImage(source: ImageSource.camera, imageQuality: 50);
                                if (image != null) {
                                  scanImage(image);
                                }
                            },

                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              minRadius: 40,
                              child: Icon(CupertinoIcons.camera,size:40,color: Colors.black,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Capture",style: TextStyle(
                              fontSize: fontSize/1.3,
                                color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                                final image = await ImagePicker()
                                    .getImage(source: ImageSource.gallery, imageQuality: 50);
                                if (image != null) {
                                  scanImage(image);
                                }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              minRadius: 40,
                              child: Icon(CupertinoIcons.photo,size:40,color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Gallery",style: TextStyle(
                                fontSize: fontSize/1.3,
                              color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              //  SizedBox(height: height * 0.13,),
                Container(
                  height: height*0.14,
                  width: double.infinity,


                  child: Column(
                    children: [
                      Text("Need Book Recommendations?",style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),),
                       Text("Try our book recommender",style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),),

                    ],
                  )
                ),
                // Container(
                //   height: height*0.1,
                //   width: double.infinity,
                //
                //   child: Center(
                //     child: Text("Try our book recommendator",style: TextStyle(
                //       fontSize: 18,
                //       color: Colors.black54,
                //     ),),
                //   ),
                // ),

                Container(
                  height: height*0.07,


                  child: RaisedButton(
                    color: Colors.orange,
                    child: Text("Try Book Recommender",style: TextStyle(
                      color: Colors.white
                    ),),
                    onPressed: (){
                      navigateTo(context, BookRecommendationInput());
                    },
                  ),
                ),
                Container(
                  height: height*0.27,
        //   color: Colors.black,
                child: Image.asset("assets/students-studying.jpg",
               //      //scale: imageScale,
                  ),
                ),

                ]
            ),
          ),
        ],
      ),
    );
  }
}

class BackGroundPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(0, size.height*0.2);

    path.quadraticBezierTo(size.width * 0.135, size.height * 0.178, size.width * 0.281, size.height*0.0889);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.0113, size.width*0.8, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.width*0.8);
    path.close();
    paint.color = Colors.yellowAccent;
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(0, size.height * 0.4);

    path.quadraticBezierTo(size.width*0.4, size.height * 0.5, size.width*0.6, size.height*0.25);

    path.quadraticBezierTo(size.width*0.7, size.height*0.15, size.width, size.height*0.1);

    path.lineTo(0, 0);
    paint.color = Colors.black87;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

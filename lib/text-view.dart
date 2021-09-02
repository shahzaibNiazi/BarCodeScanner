import 'package:firebase_ml_text_recognition/widget/text_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextView extends StatefulWidget {

 final String text;
 TextView({this.text});

  @override
  _TextViewState createState() => _TextViewState();
}
class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(

        onTap: (){
          Clipboard.setData(new ClipboardData(text: widget.text));
          print(Clipboard.getData(widget.text));

        },
        child: TextAreaWidget(
          text: widget.text
        ),
      ),
    );
  }
}

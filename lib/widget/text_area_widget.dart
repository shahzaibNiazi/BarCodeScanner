import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    @required this.text,
    @required this.onClickedCopy,
    Key key,
  }) : super(key: key);


  Future post(String route, String data) async {
    var url =
        "https://api.dictionaryapi.dev/api/v2/entries/en/$route";
    //starting web api call
    var response = await http.get(url);
//Getting server response into variable

    print(response);
    var message = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }





  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: SelectableText(
                text.isEmpty ? 'Scan an Image to get text' : text,
                showCursor: true,
                toolbarOptions: ToolbarOptions(copy: true),
                onTap:() async {
                  openLoadingDialog(
                      context, 'Recognizing Text...');

          var     result=   await post('gratitude', text);

                  Navigator.of(context).pop();

                  print(result);


                },
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // const SizedBox(width: 8),
          // IconButton(
          //   icon: Icon(Icons.copy, color: Colors.black),
          //   color: Colors.grey[200],
          //   onPressed: onClickedCopy,
          // ),
        ],
      );






  openLoadingDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(children: <Widget>[
            SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation(Colors.black))),
            SizedBox(width: 10),
            Text(text)
          ]),
        ));
  }



}

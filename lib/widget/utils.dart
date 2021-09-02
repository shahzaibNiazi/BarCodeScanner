import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Expanded(child: Text(text + "..."))
            ]),
          ));
}

openMessageDialog(BuildContext context, String text,
    [bool popTwoTimes = false]) {
  showDialog(
      context: context,
      barrierDismissible: !popTwoTimes,
      builder: (context) => AlertDialog(
            content: Column(
              children: <Widget>[
                Text(text),
                Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if (popTwoTimes) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    minWidth: 0,
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ));
}


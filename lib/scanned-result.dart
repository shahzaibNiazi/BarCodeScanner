import 'package:firebase_ml_text_recognition/model/api-model.dart';
import 'package:firebase_ml_text_recognition/services/dictionary-service.dart';
import 'package:firebase_ml_text_recognition/widget/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:language_pickers/language_picker_dialog.dart';
import 'package:language_pickers/languages.dart';
import 'package:language_pickers/utils/utils.dart';
// import 'package:translator/translator.dart';

import 'widget/meaning-bottom-sheet.dart';

class ScannedResult extends StatefulWidget {
  final String scannedResult;
  ScannedResult({this.scannedResult});
  @override
  _ScannedResultState createState() => _ScannedResultState();
}

class _ScannedResultState extends State<ScannedResult> {
  DictionaryService _meaningService = DictionaryService();
  String selectedText;
  final key = GlobalKey<ScaffoldState>();
  var myToLanguage = 'en';
  var myFromLanguage = 'en';
  var myFromLanguageName = 'English';
  var myToLanguageName = 'English';
  Language _selectedFromDialogLanguage =
  LanguagePickerUtils.getLanguageByIsoCode('en');
  Language _selectedToDialogLanguage =
  LanguagePickerUtils.getLanguageByIsoCode('en');
  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(
        language.name,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
      ),
      SizedBox(width: 4.0),
      Flexible(
          child: Text(
            "(${language.isoCode})",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
          ))
    ],
  );


  @override
  Widget build(BuildContext context) {
    final testString = widget.scannedResult;
    final textSpans = <TextSpan>[];

    testString.splitMapJoin(
      RegExp('\\w+'),
      onMatch: (m) {
        final matchStr = m.group(0);

        textSpans.add(TextSpan(
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () async {
                setState(() {
                  selectedText = matchStr;
                });
                openLoadingDialog(context, "Finding Meaning");
                List<Dictionary> result;
                var translation;
                try {
                  result = await _meaningService.getMeaning(selectedText);
                  final translator = null;
                   translation = await translator.translate(result.toString(),
                      from: myFromLanguage, to: myToLanguage);
                  print(translation);
                }
                catch (e){
                  Navigator.pop(context);
                  key.currentState.showSnackBar(
                      SnackBar(content: Text("Sorry we could not find a meaning for $selectedText."),
                        behavior: SnackBarBehavior.floating,));
                  return;
                }

                Navigator.of(context).pop();
                showMeaningBottomSheet(context,result,);

                // Navigator.pop(context);
              },
            text: matchStr,
            style: selectedText != matchStr
                ? GoogleFonts.quicksand(
                    color: Colors.black
                  )
                : GoogleFonts.quicksand(
                color: Colors.black,
                background: Paint()
                  ..color = Theme.of(context).primaryColor.withOpacity(0.4),
            )));
        return matchStr;
      },
      onNonMatch: (string) {
        textSpans.add(TextSpan(
          text: string,
        ));
        return string;
      },
    );

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Scanned Result"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: (){
              showModalBottomSheet(
                // isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),

                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FlatButton(onPressed: (){}, child: Text("Cancel",style: TextStyle(
                              //     color: Colors.grey.shade600
                              // ),)),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    openFromLanguagePickerDialog();
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10))),
                                          child: Text(
                                            "From:        $myFromLanguageName",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10))),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  openToLanguagePickerDialog();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 60.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10))),
                                          child: Text(
                                            "To:        $myToLanguageName",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10))),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      )));





          })
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(fontSize: 15),
                children: textSpans,
              ),
            ),
          ),
        ),
      ),
    );
  }



  void openFromLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
        child: LanguagePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.deepOrangeAccent,
            searchInputDecoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            isSearchable: true,
            title: Text(
              'Select your language',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
            ),
            onValuePicked: (Language language) => setState(() {
              _selectedFromDialogLanguage = language;
              myFromLanguageName = _selectedFromDialogLanguage.name;
              myFromLanguage = _selectedFromDialogLanguage.isoCode;
            }),
            itemBuilder: _buildDialogItem)),
  );
  void openToLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
        child: LanguagePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.deepOrangeAccent,
            searchInputDecoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            isSearchable: true,
            title: Text(
              'Select your language',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
            ),
            onValuePicked: (Language language) => setState(() {
              _selectedToDialogLanguage = language;
              myToLanguageName = _selectedToDialogLanguage.name;
              myToLanguage = _selectedToDialogLanguage.isoCode;
            }),
            itemBuilder: _buildDialogItem)),
  );




}

String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis luctus rutrum est, eu fermentum velit molestie sit amet. Fusce vel maximus justo. Mauris a diam et tellus tempus scelerisque non ut ex. Nam gravida ligula at orci tempor, id dignissim ex ultrices. Praesent id mi ligula. Maecenas a convallis odio, et commodo nisi. In hac habitasse platea dictumst.Pellentesque luctus sit amet dui sit amet tincidunt. Sed id felis vel ipsum blandit blandit. Maecenas facilisis volutpat est ut scelerisque. Sed sit amet diam consectetur, porttitor velit ac, dictum lorem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis pharetra dolor in nulla imperdiet, sed hendrerit ex ullamcorper. Ut et malesuada ante. Vestibulum interdum justo non est molestie suscipit. Cras pellentesque turpis id diam tempor scelerisque. Proin metus nisi, luctus ut sem ac, iaculis mattis mauris. Aliquam in pharetra nulla. Donec egestas ex non enim consectetur, non porta odio volutpat.Vestibulum mi mi, dignissim ac quam gravida, cursus pulvinar mi. Duis id rutrum arcu. Curabitur sodales consequat lacinia. Morbi ornare mollis leo. Morbi accumsan ac ex quis malesuada. Morbi dui eros, posuere quis odio vel, commodo rutrum lorem. Maecenas tempor vestibulum eleifend. Donec volutpat mauris in sodales scelerisque. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam facilisis iaculis arcu, ut commodo libero";

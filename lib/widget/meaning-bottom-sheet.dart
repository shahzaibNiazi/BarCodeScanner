import 'package:firebase_ml_text_recognition/model/api-model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showMeaningBottomSheet(BuildContext context,List<Dictionary> meaning,){
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
                  for (var res in meaning) meaningWidget(dictionary: res)
                ],
              ),
            ),
          )));
}

Widget meaningWidget({Dictionary dictionary}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dictionary.word,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            RaisedButton(
                child: Text("Translate"),

              onPressed: (){





              },


            )

          ],
        ),
        Text(dictionary.phonetics!=null && dictionary.phonetics.isNotEmpty ? dictionary.phonetics[0].text : '',style: TextStyle(fontStyle: FontStyle.italic),),
        SizedBox(height: 10,),
        Text("${dictionary.meanings[0].partOfSpeech}",style: TextStyle(fontWeight: FontWeight.bold),),
        for(int i=0; i<dictionary.meanings[0].definitions.length; ++i)
          definition(i+1,dictionary.meanings[0].definitions[i])
      ],
    ),
  );
}

Widget definition(int index, Definition definition){
  print(definition.example);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical:8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$index: ${definition.definition}"),
       definition.example !=null && definition.example.isNotEmpty ? RichText(
          text: TextSpan(
            text: 'Example: ',
            style: GoogleFonts.quicksand(
              color: Colors.black87,
            ),
            children: <TextSpan>[
              TextSpan(text: definition.example, style: TextStyle(
                  color: Colors.black,
              )),
            ],
          ),
        ) : SizedBox(),
        definition.synonyms!= null && definition.synonyms.isNotEmpty ? Text("Synonyms : ${definition.synonyms}") : SizedBox(),
      ],
    ),
  );
}
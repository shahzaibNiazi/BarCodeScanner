import 'package:firebase_ml_text_recognition/api/acp-services.dart';
import 'package:firebase_ml_text_recognition/model/api-model.dart';
import 'package:firebase_ml_text_recognition/model/api-model.dart';

class DictionaryService extends RestService<Dictionary>{
  @override
  Dictionary parse (Map<String, dynamic> json) {
    return Dictionary.fromJson(json);
  }

  Future<List<Dictionary>> getMeaning (String word){
    return super.getAll('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
  }

}
import 'package:firebase_ml_text_recognition/api/acp-services.dart';
import 'package:firebase_ml_text_recognition/model/book-recommendation.dart';

class RecommendationService extends RestService<BookRecommendation>{
  @override
  BookRecommendation parse (Map<String, dynamic> json) {
    return BookRecommendation.fromJson(json);
  }

  Future<BookRecommendation> getRecommendation (String bookName){
    return super.getOne('https://tastedive.com/api/similar?q=$bookName&type=books');
  }

}
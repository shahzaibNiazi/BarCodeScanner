import 'package:firebase_ml_text_recognition/model/api-model.dart';
import 'package:http/http.dart' as http;

Future<List<Dictionary>> fetchProducts() async {
  String url =
      "https://vindictive-acceptan.000webhostapp.com/DashBoard/api/productinfo.php";
  final response = await http.get(url);
  return welcomeFromJson(response.body);
}

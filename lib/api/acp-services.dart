import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class RestService<T> {
  Dio dio = Dio();

  Future<List<T>> getAll(String route) async {
    print(route);
    final response = await http.get(route);

    switch(response.statusCode){
      case 200:
        final decodedData = await compute<String, List<Map<String, dynamic>>>(_decodeData, response.body);
        return decodedData.map((item) => parse(item)).toList();
        break;
      case 401:
        break;
      case 404:
        throw Exception("404 error Error while fetching Data. from $route");
        break;
      case 405:
        throw Exception("405 error Error while fetching Data. from $route");
        break;
      case 422:
        throw Exception("422 error Error while fetching Data. from $route");
        break;
      case 500:
        throw Exception("${response.body} 500 error Error while fetching Data. from $route");
        break;
      default:
    }
  }

    static List<Map<String, dynamic>> _decodeData(String encodedData) {
    final json = jsonDecode(encodedData);

    if (json is List) {
      return json.cast<Map<String, dynamic>>();
    } else {
      return [json].cast<Map<String, dynamic>>();
    }
  }

  Future<T> getOne(String route) async {
    print(route);

    try {
      final response = await Dio().get(route);
      return parse(response.data);
    }
    on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
      return e.response.data['message'];
    }

  }

  T parse(Map<String, dynamic> json);

}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/data/weather.dart';

class HttpHelper{
  //http://api.openweathermap.org/data/2.5/weather?q=London&appid=c71438dd2d1133696a33ee6d7bf2af62
  final String authority = 'api.openweathermap.org';
  final String path = 'data/2.5/weather';
  final String apiKey = 'c71438dd2d1133696a33ee6d7bf2af62';

  Future<Weather> getWeather(String location) async{
      Map<String, dynamic> parameters = {'q': location, 'appId': apiKey};
      Uri uri = Uri.https(authority, path, parameters);
      http.Response result = await http.get(uri);
      Map<String, dynamic> data = json.decode(result.body);
      Weather weather = Weather.fromJson(data);
      return weather;
  }
}
import 'package:dio/dio.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/repository/remote/url.dart';

BaseOptions options = BaseOptions(
  connectTimeout: 15000,
  receiveTimeout: 30000,
  responseType: ResponseType.json,
);

Dio dio = Dio(options);

Future<UserData> getUserSummary(String apiKey, String start, String end) async {
  Response response;
  var url = URLs.GET_USER_SUMMARY + "?start=$start&end=$end&api_key=$apiKey";
  print(url);
  try {
    response = await dio.get(url);
    if (response.statusCode == 200) {
      print(response.data.toString());
      return UserData.fromJson(response.data);
    } else {
      return null;
    }
  } on DioError catch (e) {
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request.path);
      print(e.message);
    }
  }
  return null;
}

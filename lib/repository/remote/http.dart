import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:waka/repository/model/user.dart';
import 'package:waka/repository/model/user_data.dart';
import 'package:waka/repository/model/users_activity.dart';
import 'package:waka/repository/remote/url.dart';

BaseOptions options = BaseOptions(
  connectTimeout: 15000,
  receiveTimeout: 30000,
  responseType: ResponseType.json,
);

Dio dio = Dio(options);

Future<User> login(String username, String password) async {
  Response response;
  var url = URLs.LOGIN;
  print(url);
  try {
    response = await dio.post(url,
        data: json.encode({"username": username, "password": password}));
    if (response.statusCode == 200) {
      print(response.data.toString());
      return User.fromJson(response.data);
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

Future<User> register(String apiKey, String username, String password) async {
  Response response;
  var url = URLs.REGISTER;
  print(url);
  try {
    response = await dio.post(url,
        data: json.encode(
            {"api_key": apiKey, "username": username, "password": password}));
    if (response.statusCode == 200) {
      print(response.data.toString());
      return User.fromJson(response.data);
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

Future<UsersActivity> getAllUsersSummary(String start, String end) async {
  Response response;
  var url = URLs.ALL_USER_SUMMARY + start + "/" + end;
  print(url);
  try {
    response = await dio.get(url);
    if (response.statusCode == 200) {
      print(response.data.toString());
      return UsersActivity.fromJson(response.data);
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

Future<UsersActivity> getAllUsers97Summary(String start, String end) async {
  Response response;
  var url = URLs.ALL_USER97_SUMMARY + start + "/" + end;
  print(url);
  try {
    response = await dio.get(url);
    if (response.statusCode == 200) {
      print(response.data.toString());
      return UsersActivity.fromJson(response.data);
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

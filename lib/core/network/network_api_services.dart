import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../local/shared_preferences_helper.dart';
import 'base_api_services.dart';

class NetworkApiService implements BaseApiServices {
  final Dio _dio = Dio();

  NetworkApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  Future<Map<String, String>> _getHeaders({bool isJson = false}) async {
    final headers = {
      'Device-ID': "${SharedPreferencesHelper.getString(AppConstants.DEVICE_ID)}",
    };
    if (isJson) headers['Content-Type'] = 'application/json';
    return headers;
  }

  @override
  Future<dynamic> getApi(String url) async {
    try {
      final headers = await _getHeaders();
      if (kDebugMode) {
        print("AccessToken==>Bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}");
        print("GET => $url");
        print("Headers => $headers");
      }

      final response = await _dio.get(url, options: Options(headers: headers));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data) async {
    try {
      final headers = await _getHeaders();
      if (kDebugMode) {
        print("AccessToken==>Bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}");
        print("POST => $url");
        debugPrint("Body => $data", wrapWidth: 1024);
      }

      final response = await _dio.post(url, data: data, options: Options(headers: headers));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> putApi(String url, dynamic data) async {
    try {
      final headers = await _getHeaders();
      if (kDebugMode) {
        print("PUT => $url");
        debugPrint("Body => $data", wrapWidth: 1024);
      }

      final response = await _dio.put(url, data: data, options: Options(headers: headers));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> loginApi(String url, dynamic data) async {
    try {
      final headers = await _getHeaders();
      if (kDebugMode) {
        print("Login POST => $url");
        print("Body => $data");
      }

      final response = await _dio.post(url, data: data, options: Options(headers: headers));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> estimationCreateApi(String url, dynamic data) async {
    try {
      final headers = await _getHeaders(isJson: true);
      if (kDebugMode) {
        print("POST JSON => $url");
        debugPrint("Body => $data", wrapWidth: 1024);
      }

      final response = await _dio.post(url,
          data: jsonEncode(data), options: Options(headers: headers));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (kDebugMode) {
      print("STATUS_CODE => ${response.statusCode}");
      print("RESPONSE => ${response.data}");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
        return response.data;
      case 401:
      // handle 401 navigation here if needed
        return null;
      case 404:
      case 500:
        throw UnauthorisedException(response.data.toString());
      default:
        throw FetchDataException('Unexpected error: ${response.statusCode}');
    }
  }

  void _handleDioException(DioException error) {
    if (kDebugMode) {
      print("DIO ERROR => ${error.message}");
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      throw FetchDataException('Network Request time out');
    } else if (error.type == DioExceptionType.badResponse) {
      final response = error.response;
      if (response != null) {
        throw FetchDataException('Server error: ${response.statusCode}');
      }
    } else if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      throw NoInternetException('No Internet Connection');
    }

    throw FetchDataException('Something went wrong');
  }
}

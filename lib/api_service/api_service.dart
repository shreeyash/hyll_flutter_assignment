import 'dart:convert';
import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'app_exceptions.dart';

abstract class API {
  void setBaseUrl(String url);
  dynamic returnResponse(http.Response response);

  Future<dynamic> getData(String url,
      {required String token, Map<String, dynamic>? queryParams});
  Future<dynamic> postData(
    String url, {
    required Map<String, dynamic> body,
    required String token,
    required String uid,
  });
  Future<dynamic> putData(
    String url, {
    required Map<String, dynamic> body,
    required String token,
    required String uid,
  });
  Future<dynamic> deleteData(
    String url, {
    required Map<String, dynamic> body,
    required String token,
    required String uid,
  });
  Future<dynamic> patchData(
    String url, {
    Map<String, dynamic> body,
    required String token,
    required String uid,
  });
}

class ApiService extends GetxService implements API {
  static ApiService instance = ApiService();
  static var client = http.Client();

  final Logger _logger = Logger();

  @override
  Future getData(
    String url, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    var responseJson;
    try {
      Map<String, String> headers = {};

      if (token != null) headers = {"Authorization": "Bearer $token"};

      _logger.i("Calling api : $url");
      var response = await client.get(Uri.parse(url), headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      rethrow;
    } on BadRequestException {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future deleteData(
    String url, {
    Map<String, dynamic>? body,
    required String uid,
    required String token,
  }) async {
    var responseJson;

    try {
      Map<String, String> headers = {};
      headers = {
        "Authorization": "Bearer $token"
        // "uid": uid,
      };

      final response = await client.delete(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      throw UnauthorisedException("Token Expired, Signout current user");
    }
    return responseJson;
  }

  @override
  Future patchData(
    String url, {
    Map<String, dynamic>? body,
    required String uid,
    required String token,
  }) {
    // TODO: implement patchData
    throw UnimplementedError();
  }

  @override
  Future postData(
    String url, {
    required Map<String, dynamic> body,
    required String uid,
    required String token,
  }) async {
    var responseJson;
    Map<String, String> headers = {};

    try {
      headers = {
        "Authorization": "Bearer $token"
        // "uid": uid,
      };
      _logger.i("url: $url \n headers $headers");
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      throw UnauthorisedException("Token Expired, Signout current user");
    } on BadRequestException {
      rethrow;
    }

    return responseJson;
  }

  @override
  Future putData(
    String url, {
    required Map<String, dynamic> body,
    required String uid,
    required String token,
  }) async {
    var responseJson;
    Map<String, String> headers = {};
    try {
      headers = {
        "Authorization": "Bearer $token"
        // "uid": uid,
      };
      final response = await client.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      throw UnauthorisedException("Token Expired, Signout current user");
    }
    return responseJson;
  }

  @override
  dynamic returnResponse(http.Response response) {
    var responseJson = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['message']);
      case 401:
        throw UnauthorisedException(responseJson['message']);
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw BadRequestException(responseJson['message']);
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  @override
  void setBaseUrl(String url) {
    // TODO: implement setBaseUrl
  }
}

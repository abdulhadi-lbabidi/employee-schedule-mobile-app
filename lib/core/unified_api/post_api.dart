import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'handling_exception_request.dart';

typedef FromJson<T> = T Function(String body);

class PostApi<T> with HandlingExceptionRequest {
  final Uri uri;
  final Map body;
  final FromJson fromJson;
  final bool isLogin;
  final Duration timeout;

  const PostApi({
    required this.uri,
    required this.body,
    required this.fromJson,
    this.isLogin = false,
    this.timeout = const Duration(seconds: 20),
  });

  Future<T> callRequest() async {
    // log('the token in the request header is $token'.logWhite, name: 'request manager ==> post function ');
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var request = http.Request('POST', uri);
      request.body = jsonEncode(body);
      request.headers.addAll(headers);
      http.StreamedResponse streamedResponse =
          await request.send().timeout(timeout);
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return fromJson(response.body);
      } else {
        Exception exception = getException(response: response);
        throw exception;
      }
    } on HttpException {
      rethrow;
    } on FormatException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

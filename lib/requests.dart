import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/Token.dart';

class ApiEndpoints {
  static String loginURL =
      'http://10.0.2.2:8080/api/login'; // 10.0.2.2 == localhost

  static String getAllPagesURL = 'http://10.0.2.2:8080/pages';
}

class ATokens {
  static String accessToken = '';
}

Future<http.Response> verify(String username, String password) async {
  final res = await http.post(
    Uri.parse(ApiEndpoints.loginURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  // return Token.fromJson(jsonDecode(res.body));
  return res;
}

Future<http.Response> getPages() async {
  final res = await http.get(Uri.parse(ApiEndpoints.getAllPagesURL), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${ATokens.accessToken}',
  });

  return res;
}

Future<http.Response> getMethod(int id) async {
  final res =
      await http.get(Uri.parse('http://10.0.2.2:8080/methods/$id'), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${ATokens.accessToken}',
  });

  return res;
}

import 'dart:async';

import 'package:http/http.dart' as http;

class Requests {

  Future<bool> checkUrl(String url) async {
    try {
      await http.get(Uri.parse("$url/v1/models"));
    } catch (_) {
      return false;
    }
    return true;
  }
}
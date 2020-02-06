import 'package:http/http.dart' as http;

Future<http.Response> getPage(String url) => http.get(url);

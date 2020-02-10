import 'package:http/http.dart';

abstract class WebServices {
  Future<Response> getPage(String url);
}

import 'package:http/http.dart';
import 'package:http_logger/http_logger.dart';
import 'package:http_middleware/http_middleware.dart';

HttpWithMiddleware httpClient = HttpWithMiddleware.build(middlewares: [
  HttpLogger(logLevel: LogLevel.BODY),
]);

Future<Response> getPage(String url) => httpClient.get(url, headers: headers);

const headers = {
  'Cache-Control': 'no-cache',
  'Accept':
      'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
  'Accept-Encoding': 'gzip, deflate',
  'Accept-Language': 'ru-RU;q=0.8',
  'Connection': 'close',
  'Upgrade-Insecure-Requests': '0',
  'Content-Type': 'text/html; charset=windows-1251',
  'User-Agent':
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
};

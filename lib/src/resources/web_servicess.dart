import 'package:http/http.dart';

Client client = Client();

Future<Response> getPage(String url) => UserAgentClient(
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
            client)
        .get(url, headers: {
      'Cache-Control': 'no-cache',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
      'Accept-Encoding': 'gzip, deflate',
      'Accept-Language': 'ru-RU;q=0.8',
      'Connection': 'close',
      'Upgrade-Insecure-Requests': '0',
      'Content-Type': 'text/html; charset=windows-1251',
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Mobile Safari/537.36',
    });

class UserAgentClient extends BaseClient {
  final String userAgent;
  final Client _inner;

  UserAgentClient(this.userAgent, this._inner);

  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    return _inner.send(request);
  }
}

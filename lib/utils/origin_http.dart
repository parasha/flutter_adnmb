import 'dart:io';
import 'dart:convert';

class _Http {
  /**
   *  GET 请求
   */
  dynamic get(String url, {Map data}) async {
    List u = splitUrl(url);
    HttpClient _httpClient = new HttpClient();
    Uri uri = new Uri.http(u[0], u[1], data);
    HttpClientRequest request = await _httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    String res = await response.transform(utf8.decoder).join();
    _httpClient.close();
    return json.decode(res);
  }

  splitUrl(String url) {
    List<String> arr = url.split('/');
    String path = '';
    for (int i = 1; i < arr.length; i++) {
      path += '/' + arr[i];
    }
    return [arr[0], path];
  }
}

_Http http = new _Http();

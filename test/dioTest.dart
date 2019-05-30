import 'package:adnmb/utils/http.dart';
// import 'package:dio/dio.dart';


void main(List<String> args) async {
  var res = await AppHttp.get('/showf', data: <String, String>{
    'id': '20',
    'page': '1',
  });

  print(res.data[0]);
}

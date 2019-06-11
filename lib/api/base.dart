import 'package:github/server.dart';
import 'package:dio/dio.dart';

GitHub defaultClient = createGitHubClient();

class Client {
  Dio _dio = new Dio();
  
  Future<String> get(String path) async{
    var resp = await _dio.get(path);
    return resp.data.toString();
  }
}
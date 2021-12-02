import 'package:http/http.dart' as http;
import 'dart:convert';

List<ApiTodoObj> apiList = <ApiTodoObj>[];

class ApiTodoObj {
  String id, title;
  bool done;
  ApiTodoObj({this.id = '', required this.title, this.done = false});

  factory ApiTodoObj.fromJson(Map<dynamic, dynamic> json) {
    return ApiTodoObj(
        id: json['id'] as String,
        title: json['title'] as String,
        done: json['done'] as bool);
  }
}

var url = 'https://todoapp-api-pyq5q.ondigitalocean.app';
var nyckel = 'ae1f049c-d87a-4c4f-b79b-18bbfbce6f24';

class Api {
//send-list anropet
  static Future<List<ApiTodoObj>> postList(ApiTodoObj input) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=ae1f049c-d87a-4c4f-b79b-18bbfbce6f24'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          "title": input.title,
          "done": input.done,
        }));

    List<dynamic> parsedList = jsonDecode(response.body);
    List<ApiTodoObj> apiList =
        List<ApiTodoObj>.from(parsedList.map((i) => ApiTodoObj.fromJson(i)));
    return apiList;
  }

//fetch-list anropet
  static Future<List<ApiTodoObj>> getList() async {
    http.Response response = await http.get(Uri.parse(
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=ae1f049c-d87a-4c4f-b79b-18bbfbce6f24'));

    List<dynamic> parsedList = jsonDecode(response.body);
    List<ApiTodoObj> apiList =
        List<ApiTodoObj>.from(parsedList.map((i) => ApiTodoObj.fromJson(i)));
    return apiList;
  }

//update-list anropet
  static Future<ApiTodoObj> putList(String title, bool done, String id) async {
    http.Response response = await http.put(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=ae1f049c-d87a-4c4f-b79b-18bbfbce6f24'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'done': done,
      }),
    );
    if (response.statusCode == 200) {
      return ApiTodoObj.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to update list');
    }
  }

  static Future<http.Response> deleteList(String id) async {
    http.Response response = await http.delete(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=ae1f049c-d87a-4c4f-b79b-18bbfbce6f24'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    return response;
  }
}

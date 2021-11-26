// ignore_for_file: file_names

import 'package:http/http.dart' as http;
import 'dart:convert';

List<ApiTodoList> apiList = <ApiTodoList>[];

class ApiTodoList {
  String id, title;
  bool done;
  ApiTodoList(this.id, this.title, this.done);

  factory ApiTodoList.fromJson(Map<String, dynamic> json) {
    return ApiTodoList(
        json['id'] as String, json['title'] as String, json['done'] as bool);
  }
}

var url = 'https://todoapp-api-pyq5q.ondigitalocean.app/';
var nyckel = 'cc02106c-4aaa-4a34-a843-93ce810acc0c';

//send-list anropet
Future<ApiTodoList> postList(String title, bool done) async {
  final response = await http.post(
    Uri.parse('$url/todos?key=$nyckel'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 201) {
    return ApiTodoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create a list');
  }
}

//fetch-list anropet
Future<ApiTodoList> getList() async {
  final response = await http.get(Uri.parse('$url/todos?key=$nyckel'));
  if (response.statusCode == 200) {
    return ApiTodoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load list');
  }
}

//update-list anropet
Future<ApiTodoList> putList(String title, bool done, String id) async {
  final response = await http.put(
    Uri.parse('$url/todos/$id?key=$nyckel'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'done': false,
    }),
  );
  if (response.statusCode == 200) {
    return ApiTodoList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update list');
  }
}

Future<http.Response> deleteList(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('$url/todos/$id?$nyckel'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  );
  return response;
}

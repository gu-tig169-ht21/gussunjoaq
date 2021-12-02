import 'package:flutter/material.dart';
import 'api.dart';

final _nameController = TextEditingController();

//-------------------Andra Sidan!!!
class AndraSidan extends StatefulWidget {
  const AndraSidan({Key? key}) : super(key: key);

  @override
  _AndraSidanState createState() => _AndraSidanState();
}

class _AndraSidanState extends State<AndraSidan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Todos'),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add todo',
              ),
            ),
          ),
          ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                ApiTodoObj test = ApiTodoObj(title: _nameController.text);
                Api.postList(test);
                _nameController.clear();
              })
        ]));
  }
}

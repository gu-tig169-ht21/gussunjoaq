import 'package:flutter/material.dart';
import 'api.dart';

final _nameController = TextEditingController();

//-------------------Andra Sidan!!!
class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
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
                ApiTodoObj input = ApiTodoObj(title: _nameController.text);
                Api.postList(input);
                _nameController.clear();
              })
        ]));
  }
}

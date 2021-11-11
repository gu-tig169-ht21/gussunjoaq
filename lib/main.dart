import 'package:flutter/material.dart';

final _lista = <String>[];
final List<String> _saved = <String>[];

void main() => runApp(const MaterialApp(home: StartSidan()));

class StartSidan extends StatefulWidget {
  const StartSidan({Key? key}) : super(key: key);

  @override
  _StartSidanState createState() => _StartSidanState();
}

//--------------Första sidan!!!
class _StartSidanState extends State<StartSidan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG169 Att göra'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
      ),
      body: lista(),
      floatingActionButton: FloatingActionButton(
        //navigator till andra sidan
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AndraSidan()),
          ).then(
            (value) => setState(() {}),
          );
        },
      ),
    );
  }

  Widget byggRad(String pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair,
          style: TextStyle(
            decoration: alreadySaved ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Icon(
          alreadySaved
              ? Icons.check_circle_outline
              : Icons.check_circle_outline_outlined,
          color: alreadySaved ? Colors.green : null,
        ),
        trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _lista.remove(pair);
              });
            }),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  Widget lista() {
    //ListView/Listan
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          final index = i;
          if (index < _lista.length) {
            return byggRad(_lista[index]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }
}

//-------------------Andra Sidan!!!
class AndraSidan extends StatefulWidget {
  const AndraSidan({Key? key}) : super(key: key);

  @override
  _AndraSidanState createState() => _AndraSidanState();
}

class _AndraSidanState extends State<AndraSidan> {
  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    //knappen för att lägga till på andra sidan
    setState(() {
      _lista.add(nameController.text);
      nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lägg till uppgifter'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vad skall du göra?',
              ),
            ),
          ),
          ElevatedButton(
              child: const Text('Lägg till'),
              onPressed: () {
                addItemToList();
              })
        ]));
  }
}

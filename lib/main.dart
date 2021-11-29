import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

List<ApiTodoList> _lista = <ApiTodoList>[];
//final List<String> _saved = <String>[];
String filter = 'Alla';
final _nameController = TextEditingController();

void main() => runApp(
    const MaterialApp(home: StartSidan(), debugShowCheckedModeBanner: false));

class StartSidan extends StatefulWidget {
  const StartSidan({Key? key}) : super(key: key);

  @override
  _StartSidanState createState() => _StartSidanState();
}

//--------------Första sidan!!!
class _StartSidanState extends State<StartSidan> {
  final _filtermenu = ['Alla', 'Klar', 'Ej Klar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<String>(
            hint: const Text('Filtrering'),
            dropdownColor: Colors.grey,
            icon: const Icon(Icons.more_vert),
            items: _filtermenu.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: (String? newValueSelected) {
              setState(() {
                filter = newValueSelected!;
              });
            },
            value: filter,
          ),
        ],
        title: const Text('TIG169 Att göra'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
      ),
      body: filtrering(filter),
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

  Widget byggRad(ApiTodoList pair) {
    //här!!!!

    //bygg rad till första sidan
    final alreadySaved = pair.done; /*_saved.contains(pair);*/

    _lista.contains(pair) ? null : _lista.add(pair); //här
    return ListTile(
      title: Text(
        pair.title,
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
      onTap: () {
        int index = _lista.indexWhere((item) => item.id == pair.id);
        if (alreadySaved) {
          putList(pair.title, false, pair.id);
          setState(() {
            _lista[index].done = false;
          });
        } else {
          putList(pair.title, true, pair.id);
          setState(() {
            _lista[index].done = true;
          });
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            deleteList(pair.id);
            setState(() {
              _lista.removeWhere((element) => element.id == pair.id);
              //_lista.remove(pair);
            });
          }),
      /* onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        }*/
    );
  }

  Widget filtrering(String x) {
    // widget för filtreringsrutan
    //List<String> ejklar = <String>[];
    switch (x) {
      case 'Alla':
        {
          return lista(_lista);
        }

      case 'Klar':
        {
          return lista(_lista.where((todo) => todo.done == true).toList());
        }

      case 'Ej Klar':
        {
          /*for (int i = 0; i < _lista.length; i++) {
            if (!_saved.contains(_lista[i])) {
              ejklar.add(_lista[i]);
            }
          }*/
          return lista(_lista
              .where((todo) => todo.done == false)
              .toList()); //lista(ejklar);
        }

      default:
        {
          return lista(_lista);
        }
    }
  }

  Widget lista(List<ApiTodoList> filtrering) {
    //här!!!
    //ListView/Listan
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          final index = i;
          if (index < filtrering.length) {
            return byggRad(filtrering[index]);
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
  /*void addItemToList() {
    //knappen för att lägga till på andra sidan
    setState(() {
      _lista.add(_nameController.text);
      _nameController.clear();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lägg till uppgifter'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vad skall du göra?',
              ),
            ),
          ),
          ElevatedButton(
              child: const Text('Lägg till'),
              onPressed: () {
                setState(() {
                  putList(_nameController.text, false, _nameController.text);
                  getList();
                  _lista = List.from(apiList);
                  _nameController.clear();
                });
              })
        ]));
  }
}

import 'package:flutter/material.dart';
import 'api.dart';
import 'secondpage.dart';
import 'theme.dart';

List<ApiTodoObj> _lista = <ApiTodoObj>[];

String filter = 'All';

Future<List<ApiTodoObj>>? futureApiTodoList;

void main() => runApp(MaterialApp(
    home: const StartSidan(),
    theme: CustomTheme.standardTheme,
    debugShowCheckedModeBanner: false));

class _GettingApi {
  Future<List<ApiTodoObj>> apiGet() async {
    _lista = await Api.getList();
    return _lista;
  }
}

class StartSidan extends StatefulWidget {
  const StartSidan({Key? key}) : super(key: key);

  @override
  _StartSidanState createState() => _StartSidanState();
}

//--------------Första sidan!!!
class _StartSidanState extends State<StartSidan> {
  final _filtermenu = ['All', 'Done', 'Undone'];

  @override
  void initState() {
    futureApiTodoList = _GettingApi().apiGet();
    super.initState();
  }

  void post(ApiTodoObj test) async {}

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
        title: const Text('TIG169 Todo-list'),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return filtrering(filter);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
          future: futureApiTodoList,
        ),
      ),
      //navigator till andra sidan
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AndraSidan()),
          ).then(get);
        },
      ),
    );
  }

  Future? get(dynamic value) {
    setState(() {
      futureApiTodoList = _GettingApi().apiGet();
    });
  }

  //bygg rad till första sidan
  Widget byggRad(ApiTodoObj pair) {
    final alreadySaved = pair.done;

    _lista.contains(pair) ? null : _lista.add(pair);
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
          Api.putList(pair.title, false, pair.id);
          setState(() {
            _lista[index].done = false;
          });
        } else {
          Api.putList(pair.title, true, pair.id);
          setState(() {
            _lista[index].done = true;
          });
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            Api.deleteList(pair.id);
            setState(() {
              _lista.removeWhere((element) => element.id == pair.id);
            });
          }),
    );
  }

  // widget för filtreringsrutan
  Widget filtrering(String x) {
    switch (x) {
      case 'All':
        {
          return lista(_lista);
        }

      case 'Done':
        {
          return lista(_lista.where((todo) => todo.done == true).toList());
        }

      case 'Undone':
        {
          return lista(_lista.where((todo) => todo.done == false).toList());
        }

      default:
        {
          return lista(_lista);
        }
    }
  }

  //ListView/Listan
  Widget lista(List<ApiTodoObj> filtrering) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i < filtrering.length) {
            return byggRad(filtrering[i]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }
}

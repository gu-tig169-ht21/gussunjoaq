import 'package:flutter/material.dart';
import 'api.dart';
import 'secondpage.dart';
import 'theme.dart';

List<ApiTodoObj> _lista = <ApiTodoObj>[];

String filter = 'All';

Future<List<ApiTodoObj>>? futureApiTodoList;

void main() => runApp(MaterialApp(
    home: const FirstPage(),
    theme: CustomTheme.standardTheme,
    debugShowCheckedModeBanner: false));

class _GettingApi {
  Future<List<ApiTodoObj>> apiGet() async {
    _lista = await Api.getList();
    return _lista;
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

//--------------Första sidan!!!
class _FirstPageState extends State<FirstPage> {
  final _filtermenu = ['All', 'Done', 'Undone'];

  @override
  void initState() {
    futureApiTodoList = _GettingApi().apiGet();
    super.initState();
  }

  void post(ApiTodoObj input) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<String>(
            hint: const Text('Filtrering'),
            dropdownColor: Colors.white,
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
            MaterialPageRoute(builder: (context) => const SecondPage()),
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
  Widget byggRad(ApiTodoObj obj) {
    final alreadySaved = obj.done;

    _lista.contains(obj) ? null : _lista.add(obj);
    return ListTile(
      title: Text(
        obj.title,
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
        int index = _lista.indexWhere((item) => item.id == obj.id);
        if (alreadySaved) {
          Api.putList(obj.title, false, obj.id);
          setState(() {
            _lista[index].done = false;
          });
        } else {
          Api.putList(obj.title, true, obj.id);
          setState(() {
            _lista[index].done = true;
          });
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            Api.deleteList(obj.id);
            setState(() {
              _lista.removeWhere((element) => element.id == obj.id);
            });
          }),
    );
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
}

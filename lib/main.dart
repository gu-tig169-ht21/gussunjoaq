import 'package:flutter/material.dart';
import 'api.dart';
import 'secondpage.dart';
import 'theme.dart';

void main() => runApp(MaterialApp(
    home: const FirstPage(),
    theme: CustomTheme.standardTheme,
    debugShowCheckedModeBanner: false));

class _GettingApi {
  Future<List<ApiTodoObj>> apiGet() async {
    _FirstPageState._list = await Api.getList();
    return _FirstPageState._list;
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
  static List<ApiTodoObj> _list = <ApiTodoObj>[];
  String filter = 'All';
  Future<List<ApiTodoObj>>? futureApiTodoList;

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
      onTap: () async {
        if (alreadySaved) {
          await Api.putList(obj.title, false, obj.id);
          _list = await Api.getList();
          setState(() {});
        } else {
          await Api.putList(obj.title, true, obj.id);
          _list = await Api.getList();
          setState(() {});
        }
      },
      trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            await Api.deleteList(obj.id);
            setState(() {
              _list.removeWhere((element) => element.id == obj.id);
            });
          }),
    );
  }

  //ListView/Listan
  Widget lista(List<ApiTodoObj> filtrering) {
    return ListView.builder(
        itemCount: filtrering.length,
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
          return lista(_list);
        }

      case 'Done':
        {
          return lista(_list.where((todo) => todo.done == true).toList());
        }

      case 'Undone':
        {
          return lista(_list.where((todo) => todo.done == false).toList());
        }

      default:
        {
          return lista(_list);
        }
    }
  }
}

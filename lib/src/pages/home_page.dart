import 'package:flutter/material.dart';
import 'package:learn/src/models/to_do.dart';
import 'package:learn/src/pages/add_to_do_page.dart';
import 'package:learn/src/pages/to_do_detail_page.dart';
import 'package:learn/src/utils/date.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _toDos = <ToDo>[];

  void _onOpenAddToDoPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddToDoPage(
                  refreshCallback: _refreshCallback,
                )));
  }

  void _onOpenDetailPage(BuildContext context, ToDo toDo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ToDoDetailPage(
                  refreshCallback: _refreshCallback,
                  toDo: toDo,
                )));
  }

  Future<void> _onDeleteToDo(BuildContext context, int index) async {
    final ok = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok) {
      _toDos.removeAt(index);
      setState(() {});
    }
    ;
  }

  void _refreshCallback(void Function(List<ToDo>) f) {
    f(_toDos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          IconButton(
            onPressed: () => _onOpenAddToDoPage(context),
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _toDos.length,
        itemBuilder: (_, index) {
          final _toDo = _toDos[index];
          return Card(
            child: ListTile(
              onTap: () => _onOpenDetailPage(context, _toDo),
              title: Text(_toDo.title),
              subtitle: Text(Date.format(_toDo.date)),
              trailing: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _onDeleteToDo(context, index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

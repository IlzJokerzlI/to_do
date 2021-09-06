import 'package:flutter/material.dart';
import 'package:learn/src/models/to_do.dart';
import 'package:learn/src/utils/date.dart';

class AddToDoPage extends StatefulWidget {
  final void Function(void Function(List<ToDo>)) refreshCallback;

  AddToDoPage({
    required this.refreshCallback,
  });

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _selectedDate = Date.currentDate();
  final _titleNode = FocusNode();
  final _descriptionNode = FocusNode();

  Future<void> _onTapDateField(BuildContext context) async {
    final _selectedDate = await showDatePicker(
      context: context,
      initialDate: this._selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 100),
      ),
    );
    if (_selectedDate != null) {
      _dateController.text = Date.format(_selectedDate);
      this._selectedDate = _selectedDate;
    }
  }

  Future<void> _onAddToDo(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to add a new to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.refreshCallback(
                (toDos) => toDos.insert(
                  0,
                  ToDo(
                    title: _titleController.text,
                    date: _selectedDate,
                    description: _descriptionController.text,
                  ),
                ),
              );
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok) Navigator.pop(context);
  }

  @override
  void initState() {
    _dateController.text = Date.format(_selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To Do'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onAddToDo(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  focusNode: _titleNode,
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    _titleNode.unfocus();
                    _descriptionNode.requestFocus();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => ((value ?? '').isEmpty) ? 'Please fill in title!' : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _onTapDateField(context),
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                focusNode: _descriptionNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onAddToDo(context),
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

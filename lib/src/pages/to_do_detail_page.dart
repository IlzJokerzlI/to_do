import 'package:flutter/material.dart';
import 'package:learn/src/models/to_do.dart';
import 'package:learn/src/utils/date.dart';

class ToDoDetailPage extends StatefulWidget {
  final void Function(void Function(List<ToDo>)) refreshCallback;
  final ToDo toDo;

  ToDoDetailPage({
    required this.refreshCallback,
    required this.toDo,
  });

  @override
  _ToDoDetailPageState createState() => _ToDoDetailPageState();
}

class _ToDoDetailPageState extends State<ToDoDetailPage> {
  var _isEditing = false;
  var _isDataChanged = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _selectedDate = DateTime.now();
  final _titleNode = FocusNode();
  final _descriptionNode = FocusNode();

  void _onChangeEditMode() {
    _isEditing = !_isEditing;
    setState(() {});
  }

  void _checkChanges() {
    if (widget.toDo.title == _titleController.text && widget.toDo.date.compareTo(_selectedDate) == 0 && widget.toDo.description == _descriptionController.text) {
      _isDataChanged = false;
    } else {
      _isDataChanged = true;
    }
    setState(() {});
  }

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
    _checkChanges();
  }

  Future<void> _onEditToDo(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to edit this to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.toDo.title = _titleController.text;
              widget.toDo.date = _selectedDate;
              widget.toDo.description = _descriptionController.text;
              widget.refreshCallback((_) {});
              _onChangeEditMode();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _titleController.text = widget.toDo.title;
    _selectedDate = widget.toDo.date;
    _descriptionController.text = widget.toDo.description;
    _dateController.text = Date.format(_selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon((_isEditing) ? Icons.close : Icons.arrow_back),
          onPressed: (_isEditing) ? _onChangeEditMode : () => Navigator.pop(context),
        ),
        title: const Text('To Do Detail'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          (_isEditing) ? Icons.check : Icons.edit_outlined,
          color: (_isEditing && !_isDataChanged) ? Colors.indigo : null,
        ),
        onPressed: (_isEditing) ? ((!_isDataChanged) ? null : () => _onEditToDo(context)) : _onChangeEditMode,
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
                  enabled: _isEditing,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  focusNode: _titleNode,
                  autofocus: true,
                  onChanged: (_) => _checkChanges(),
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
                  enabled: _isEditing,
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
                enabled: _isEditing,
                controller: _descriptionController,
                maxLines: 5,
                focusNode: _descriptionNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onEditToDo(context),
                onChanged: (_) => _checkChanges(),
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

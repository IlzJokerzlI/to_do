class ToDo {
  late String title;
  late DateTime date;
  late String description;

  ToDo({
    required this.title,
    required this.date,
    this.description = '',
  });

  static ToDo fromJSON(Map<String, dynamic> json) {
    return ToDo(
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}

class Todo {
  final String id;
  final String title;
  final String description;

  Todo({required this.title, required this.description, required this.id});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

import 'dart:convert';

class Todo {
  int id;
  String name;
  bool isCompleted;
  Todo({
    this.id,
    this.name,
    this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Todo(
      id: map['id'],
      name: map['name'],
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}

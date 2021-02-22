import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget(
      {Key key, this.todos, this.onCheckBoxTap, this.onDeleteButtonTap})
      : super(key: key);
  final List<Todo> todos;
  final Function(
    Todo,
  ) onCheckBoxTap;
  final Function(int) onDeleteButtonTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (isChecked) {
                  //Todo mark todo as completed
                  todo.isCompleted = isChecked;
                  this.onCheckBoxTap(todo);
                }),
            title: Text(todo.name),
            subtitle: Text(todo.id.toString()),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  //Todo
                  onDeleteButtonTap(todo.id);
                }),
          );
        });
  }
}

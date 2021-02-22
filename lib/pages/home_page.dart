import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_api_service.dart';
import 'package:todo_app/widgets/todo_list_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  TodoAPIService todoAPIService =
      TodoAPIService("https://192.168.1.4:5001/todo");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: RefreshIndicator(
              child: FutureBuilder<List<Todo>>(
                  initialData: todos,
                  future: todoAPIService.fetchTodos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      todos = snapshot.data;
                      return TodoListWidget(
                        todos: todos,
                        onCheckBoxTap: (Todo todo) async {
                          await todoAPIService.updateTodo(todo);
                          refreshPage();
                        },
                        onDeleteButtonTap: (int todoId) async {
                          await todoAPIService.deleteTodo(todoId);
                          refreshPage();
                        },
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.active)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return Center(
                      child: Text("No Todos"),
                    );
                  }),
              onRefresh: () async {
                refreshPage();
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Todo
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void refreshPage() async {
    final todoListResponse = await todoAPIService.fetchTodos();
    setState(() {
      this.todos = todoListResponse;
    });
  }
}

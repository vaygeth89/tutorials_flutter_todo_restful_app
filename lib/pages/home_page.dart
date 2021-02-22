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

  //! Change the url to suits your network URL
  TodoAPIService todoAPIService =
      TodoAPIService("https://192.168.1.4:5001/todo/");
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
                          await updateTodo(todo);
                        },
                        onDeleteButtonTap: (int todoId) async {
                          await deleteTodo(todoId);
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
        onPressed: () async {
          await addTodo();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future addTodo() async {
     Todo newTodo = Todo(name: "Todo", isCompleted: false,id:2 );
    await todoAPIService.addTodo(newTodo);
    refreshPage();
  }

  Future deleteTodo(int todoId) async {
    await todoAPIService.deleteTodo(todoId);
    refreshPage();
  }

  Future updateTodo(Todo todo) async {
    await todoAPIService.updateTodo(todo);
    refreshPage();
  }

  void refreshPage() async {
    final todoListResponse = await todoAPIService.fetchTodos();
    setState(() {
      this.todos = todoListResponse;
    });
  }
}

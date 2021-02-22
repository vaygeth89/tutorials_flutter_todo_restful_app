import 'dart:convert';
import 'dart:io';

import 'package:todo_app/models/todo.dart';
import 'package:http/http.dart' as httpLibrary;

class TodoAPIService {
  final String domainName;
  //Default http headers to accept and receive json
  final httpHeaders = {
    "content-type": "application/json",
    "accept": "application/json",
  };
  TodoAPIService(this.domainName);

  //API call to create new Todo
  Future<Todo> addTodo(Todo toBeAddedTodo) async {
    httpLibrary.Response response = await httpLibrary.post(domainName,
        body: toBeAddedTodo.toJson(), headers: httpHeaders);
    if (response.statusCode == 200) {
      return Todo.fromJson(response.body);
    }
    throw HttpException("Adding Task Failed error");
  }

  //API call to get list of Todos
  Future<List<Todo>> fetchTodos() async {
    httpLibrary.Response response =
        await httpLibrary.get(domainName, headers: httpHeaders);
    if (response.statusCode == 200) {
      Iterable iterable = json.decode(response.body);
      return List<Todo>.from(iterable.map((todo) => Todo.fromMap(todo)))
          .toList();
    }
    throw HttpException("Fetching Todo failed");
  }

  //API call to delete the Todo
  Future<void> deleteTodo(int todoId) async {
    httpLibrary.Response response =
        await httpLibrary.delete(domainName + "$todoId", headers: httpHeaders);
    if (response.statusCode == 200) {
      return;
    }
    throw HttpException("Couldn't not delete Todo");
  }

  //API call to update the Todo
  Future<Todo> updateTodo(Todo toBeUpdatedTodo) async {
    httpLibrary.Response response = await httpLibrary.put(
        domainName + "${toBeUpdatedTodo.id}",
        body: toBeUpdatedTodo.toJson(),
        headers: httpHeaders);
    if (response.statusCode == 200) {
      return Todo.fromJson(response.body);
    }
    throw HttpException("Couldn't not delete Todo");
  }
}

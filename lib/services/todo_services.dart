import 'package:dio/dio.dart';
import 'package:flutter_application/model/todo.dart';

class TodoService {
  final Dio _dio = Dio();

  final String baseUrl =
      'https://todo-a9a1f-default-rtdb.firebaseio.com/todos.json';

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get(
        baseUrl,
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<Todo> todos = [];

        if (data is Map<String, dynamic>) {
          data.forEach((key, value) {
            value['id'] = key;
            todos.add(Todo.fromJson(value));
          });
        } else if (data is List) {
          todos = data.map((item) => Todo.fromJson(item)).toList();
        } else {
          todos.add(Todo.fromJson(data));
        }

        return todos;
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo(Map<String, dynamic> todo) async {
    try {
      final response = await _dio.post(baseUrl, data: todo);
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      throw Exception('Error adding todo: $e');
    }
  }

  Future<void> deleteTodoById(String id) async {
    try {
      final deleteUrl =
          "https://todo-a9a1f-default-rtdb.firebaseio.com/todos/$id.json";
      final response = await _dio.delete(deleteUrl);

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to delete todo with id $id');
      }
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }

  Future<void> editTodo(
      String id, String newTitle, String newDescription) async {
    try {
      final response = await _dio.patch(
          "https://todo-a9a1f-default-rtdb.firebaseio.com/todos/$id.json",
          data: {
            "title": newTitle,
            "description": newDescription,
          });
      if (response.statusCode != 200) {
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      rethrow;
    }
  }
}

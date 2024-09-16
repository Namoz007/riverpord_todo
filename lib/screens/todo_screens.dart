import 'package:flutter/material.dart';
import 'package:flutter_application/model/todo.dart';
import 'package:flutter_application/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final todoListAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: todoListAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Text('No todos available', style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(todo.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Edit Todo',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        labelText: 'Title',
                                        border: const OutlineInputBorder(),
                                        hintText: todo.title,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                        border: const OutlineInputBorder(),
                                        hintText: todo.description,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(todoAddProvider.notifier)
                                          .editTodo(
                                            todo.id,
                                            titleController.text.isEmpty
                                                ? todo.title
                                                : titleController.text,
                                            descriptionController.text.isEmpty
                                                ? todo.description
                                                : descriptionController.text,
                                          );
                                      ref.refresh(todoListProvider);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit,
                            color: Color.fromARGB(255, 109, 154, 190),
                            size: 25),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(todoAddProvider.notifier)
                              .deleteTodoById(todo.id);
                          ref.refresh(todoListProvider);
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 25),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child:
                Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Todo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(todoAddProvider.notifier).addTodo(
                        {
                          'title': titleController.text,
                          'description': descriptionController.text,
                        },
                      );
                      ref.refresh(todoListProvider);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

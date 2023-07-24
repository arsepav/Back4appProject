import "package:flutter/material.dart";
import "package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart";
import 'package:back4apptest/emojiChoosing.dart';
import 'dart:ui' as ui;
import 'main.dart';

class Todo {
  String objectId;
  int createdAt = 0;
  bool done;
  int emoji;
  String title;
  String parent;
  List<Todo> children = [];

  Todo({
    required this.objectId,
    this.createdAt = 0,
    required this.done,
    required this.emoji,
    required this.title,
    this.parent = '-',
  });

  factory Todo.fromParseObject(ParseObject parseObject) {
    return Todo(
      objectId: parseObject.get<String>('objectId') ?? '-',
      title: parseObject.get<String>('title') ?? 'no title...',
      done: parseObject.get<bool>('done') ?? false,
      emoji: parseObject.get<int>('emoji') ?? 0,
      parent: parseObject.get<String>('parent') ?? '-',
      createdAt: 0,
    );
  }
}

class TodoList extends StatelessWidget {
  List<ParseObject> todoList;
  final ui.VoidCallback? onPressedDelete;
  final ui.VoidCallback? onPressedCheckBox;

  TodoList(
      {super.key,
      required this.todoList,
      required this.onPressedDelete,
      required this.onPressedCheckBox});

  @override
  Widget build(BuildContext context) {
    List<Todo> parsedTodos = structuredTodos(todoList);
    return
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10.0),
        itemCount: parsedTodos.length,
        itemBuilder: (context, index) {
          return TodoWidget(
            todo: parsedTodos[index],
            onPressedCheckBox: onPressedCheckBox,
            onPressedDelete: onPressedDelete,
          );
        });
  }

  List<Todo> structuredTodos(List<ParseObject> todoList) {
    List<Todo> parsedTodos = [];

    for (var todo in todoList) {
      parsedTodos.add(Todo.fromParseObject(todo));
      print(parsedTodos.last.title);
    }

    List<Todo> rootTodos = [];

    for (var todo in parsedTodos) {
      if (todo.parent == '-') {
        rootTodos.add(todo);
      }
    }

    for (var todo in parsedTodos) {
      if (todo.parent != '-') {
        for (var todoP in rootTodos) {
          if (todo.parent == todoP.objectId) {
            todoP.children.add(todo);
          }
        }
      }
    }

    for (var todo in rootTodos) {
      print(todo.title);
      for (var todoc in todo.children) {
        print("---" + todoc.title);
      }
    }

    return rootTodos;
  }
}

class TodoWidget extends StatelessWidget {
  final ui.VoidCallback? onPressedDelete;
  final ui.VoidCallback? onPressedCheckBox;
  Todo todo;

  TodoWidget(
      {super.key,
      required this.todo,
      required this.onPressedDelete,
      required this.onPressedCheckBox});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(todo.title),
          leading: CircleAvatar(
            child: todo.done ? const Icon(Icons.check) : getEmoji(todo.emoji),
            backgroundColor: todo.done ? Colors.green : Colors.blue,
            foregroundColor: Colors.white,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                  value: todo.done,
                  onChanged: (value) async {
                    onPressedCheckBox?.call();
                    await updateTodo(todo.objectId, value!);
                    // setState(() {
                    //   //Refresh UI
                    // });
                  }),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  onPressedDelete?.call();
                  await deleteTodo(todo.objectId);
                  // setState(
                  //   () {
                  //     final snackBar = SnackBar(
                  //       content: Text("Todo deleted!"),
                  //       duration: Duration(seconds: 2),
                  //     );
                  //     ScaffoldMessenger.of(context)
                  //       ..removeCurrentSnackBar()
                  //       ..showSnackBar(snackBar);
                  //   },
                  // );
                },
              ),

            ],
          ),
        ),
        TodoChildren(todos: todo.children),
      ],
    );
  }
}

class TodoChildren extends StatelessWidget {
  List<Todo> todos;

  TodoChildren({required this.todos, super.key});

  @override
  Widget build(BuildContext context) {
    // return Text("joaivjh");
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10.0),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Text(todos[index].title);
        },
    )
    ;
  }
}

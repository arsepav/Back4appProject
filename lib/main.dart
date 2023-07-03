import 'dart:async';
import 'package:back4apptest/emojiChoosing.dart';
import 'package:back4apptest/signinscreen.dart';

import 'keys.dart';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'groupKeys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    home: SignIn(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoController = TextEditingController();

  void addToDo() async {
    if (todoController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    await saveTodo(todoController.text, emojiState);
    setState(() {
      todoController.clear();
    });
  }

  void reload() async {
    setState(() {
      todoController.clear();
    });
  }

  int emojiState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parse Todo List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: todoController,
                      decoration: InputDecoration(
                          labelText: "New todo",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          emojiState++;
                        });
                      },
                      icon: getEmoji(emojiState),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.blueAccent,
                      ),
                      onPressed: addToDo,
                      child: Text("ADD")),
                ],
              )),
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getTodo(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      // return Center(
                      //   child: Container(
                      //       width: 100,
                      //       height: 100,
                      //       child: CircularProgressIndicator()),
                      // );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return Stack(
                            children: [
                              ListView.builder(
                                  padding: EdgeInsets.only(top: 10.0),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    //*************************************
                                    //Get Parse Object Values
                                    final varTodo = snapshot.data![index];
                                    final varTitle =
                                    varTodo.get<String>('title')!;
                                    final varDone = varTodo.get<bool>('done')!;
                                    final varEmoji = varTodo.get<int>('emoji')!;
                                    //*************************************

                                    return ListTile(
                                      title: Text(varTitle),
                                      leading: CircleAvatar(
                                          child: varDone
                                              ? Icon(Icons.check)
                                              : getEmoji(varEmoji),
                                      backgroundColor: varDone
                                          ? Colors.green
                                          : Colors.blue,
                                      foregroundColor: Colors.white,
                                    )
                                    ,
                                    trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    Checkbox(
                                    value: varDone,
                                    onChanged: (value) async {
                                    await updateTodo(
                                    varTodo.objectId!, value!);
                                    setState(() {
                                    //Refresh UI
                                    });
                                    }),
                                    IconButton(
                                    icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                    await deleteTodo(
                                    varTodo.objectId!);
                                    setState(() {
                                    final snackBar = SnackBar(
                                    content:
                                    Text("Todo deleted!"),
                                    duration:
                                    Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                    });
                                    },
                                    )
                                    ]
                                    ,
                                    )
                                    ,
                                    );
                                  }),
                              Positioned(
                                bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 30,
                                // Adjust this value to change the distance from the bottom
                                right: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 30,
                                // Adjust this value to change the distance from the right
                                child: SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 5,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 5,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      reload();
                                    },
                                    child: Icon(Icons.refresh,
                                        size:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  }))
        ],
      ),
    );
  }

  Future<void> saveTodo(String title, int emojiState) async {
    final todo = ParseObject(groupKey)
      ..set('title', title)..set('done', false)..set('emoji', emojiState);
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
    QueryBuilder<ParseObject>(ParseObject(groupKey));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todo = ParseObject(groupKey)
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject(groupKey)
      ..objectId = id;
    await todo.delete();
  }
}

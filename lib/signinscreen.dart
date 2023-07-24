import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'groupKeys.dart';
import 'main.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final keyController = TextEditingController();
  int keyError = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join the group"),
        backgroundColor: Color(0xCBE646FF),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                controller: keyController,
                decoration: InputDecoration(
                    labelText: "Enter the group key",
                    labelStyle: TextStyle(color: Color(0xCBE646FF))),
              ),
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  if (chekGroupKey(keyController.text)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Home(),
                      ),
                    );
                    setState(() {
                      keyError = 0;
                    });

                    groupKey = keyController.text;
                    keyController.clear();
                  } else {
                    setState(() {
                      keyError = 1;
                    });
                  }
                },
                child: SizedBox(
                    width: 100, height: 30, child: Center(child: Text("Join"))),
              );
            }),
            keyError != 0
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                      "Enter the correct key.\nCorrect key must consist of latin letters and digits",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}

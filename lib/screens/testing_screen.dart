/*
 ** Contains code that shows how to implement pre-filled textFields...
*/


//import 'package:flutter/material.dart';
/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrefilledTextFieldExample(),
    );
  }
}

class PrefilledTextFieldExample extends StatefulWidget {
  @override
  _PrefilledTextFieldExampleState createState() => _PrefilledTextFieldExampleState();
}

class _PrefilledTextFieldExampleState extends State<PrefilledTextFieldExample> {
  TextEditingController textController = TextEditingController(text: "Hello, Flutter!"); // Pre-filled text
  String updated_text = "123";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pre-filled TextField")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Modify this text",

                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updated_text = textController.text;
                setState(() {

                });
                 // Modify text dynamically
              },
              child: Text("Update Text"),
            ),
            Text(updated_text),
          ],
        ),
      ),
    );
  }
}
*/
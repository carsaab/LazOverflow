import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_question_page.dart';

class QuestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("LAZ Overflow"),
      ),
      body: Center(
        child: Text("Question Page"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          onAddQuestionButtonPress(context);
        },
      ),
    );
  }

  void onAddQuestionButtonPress(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddQuestionPage()));
  }
}

import 'package:flutter/material.dart';
import './model/todomodel.dart';
import './friend.dart';
import './model/user.dart';

class Todopage extends StatefulWidget {
  int id;
  String name;
  User user;
  Todopage({Key key, this.id, this.name, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TodopageState();
  }
}

class TodopageState extends State<Todopage> {
  TodoProvider todoProvider = TodoProvider();

  Widget listview(BuildContext context, AsyncSnapshot snapshot) {
    int id = widget.id;
    print(id);
    List<Todo> todos = snapshot.data;
    return Expanded(
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Text(
                    todos[index].id.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    todos[index].title,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    todos[index].completed ? "Completed" : "",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: todoProvider.loadTodo(id.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return listview(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
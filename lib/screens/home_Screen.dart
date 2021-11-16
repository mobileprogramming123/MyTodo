import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/Constant/Colors.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/services/auth.dart';
import 'package:todo_flutter/services/database.dart';
import 'package:todo_flutter/widgets/todo_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({
    Key key,
    this.auth,
    this.firestore,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar_color,
        title: const Text("My Todo"),
        actions: [
          IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                Auth(auth: widget.auth).signOut();
              }),
          // PopupMenuButton(
          //   onSelected: (String value) {
          //     switch (value) {
          //       case "TodoDone":
          //         //show todo done here
          //         break;
          //       default:
          //     }
          //   },
          //   itemBuilder: (BuildContext context) {
          //     final List<String> menus = ["TodoDone", "Logout"];
          //     return menus.map((menu) {
          //       return PopupMenuItem(
          //         value: menu,
          //         child: Text(menu),
          //       );
          //     }).toList();
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Write your Todo Here:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _todoController,
                  )),
                  IconButton(
                    icon: const Icon(Icons.add_box,size: 35,color: add_button_color,),
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        setState(() {
                          Database(firestore: widget.firestore).addTodo(
                              uid: widget.auth.currentUser.uid,
                              content: _todoController.text.trim());
                          _todoController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Your Todos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: Database(firestore: widget.firestore)
                .streamTodos(uid: widget.auth.currentUser.uid),
            builder:
                (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data.isEmpty) {
                  return const Center(
                    child: Text("You dont have any Todos"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return TodoCard(
                      firestore: widget.firestore,
                      uid: widget.auth.currentUser.uid,
                      todo: snapshot.data[index],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("Loading..."),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/Constant/Colors.dart';
import 'package:todo_flutter/Utils/Utils.dart';
import 'package:todo_flutter/services/auth.dart';

class auth_Screen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const auth_Screen({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);

  @override
  _auth_Screen_state createState() => _auth_Screen_state();
}

class _auth_Screen_state extends State<auth_Screen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Builder(builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Authentication",style: TextStyle(color: Colors.black,fontSize: 24),),
                SizedBox(height: 20,),


                TextFormField(

                  decoration: const InputDecoration(hintText: "Email"),
                  controller: _emailController,
                ),
                TextFormField(

                  decoration: const InputDecoration(hintText: "Password"),
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                        onTap: () async {
                  final String retVal = await Auth(auth: widget.auth).signIn(
                  email: _emailController.text,
                  password: _passwordController.text,
                  );
                  if (retVal == "Success") {
                  _emailController.clear();
                  _passwordController.clear();
                  } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(retVal)));
                  }
            },
                  child: Container(
                    alignment: Alignment.center,
                    color: login_button_color,
                    height: MediaQuery.of(context).size.height/25,
                    width: MediaQuery.of(context).size.width/1.3,
                    child: const Text("Sign In",style: TextStyle(color: Colors.white),),),
                ),
                SizedBox(height: 20,),
                InkWell(onTap :()async {
                final String retVal =
                await Auth(auth: widget.auth).createAccount(
                email: _emailController.text,
                password: _passwordController.text,
                );

                if (retVal == "Success") {
                _emailController.clear();
                _passwordController.clear();
                } else {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(retVal)));
                }
                }
                    ,child: Text("Create Account"))


              ],
            );
          }),
        ),
      ),
    );
  }
}

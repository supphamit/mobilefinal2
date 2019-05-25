import 'package:flutter/material.dart';
import 'register.dart';
import 'home.dart';
import 'model/user.dart';
import 'login.dart';
class Register extends StatefulWidget {
  @override
  LoginpageState createState() {
    return LoginpageState();
  }
}


class LoginpageState extends State<Register> {
   final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();


  //new instance
  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
   @override
   void initState() {
    super.initState();
    userProvider.open('member.db').then((r) {
      getUsers();
    });
  }

  void getUsers() {
    userProvider.getUsers().then((r) {
      setState(() {
        currentUsers = r;
      });
    });
  }

  void deleteUsers() {
    userProvider.deleteUsers().then((r) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Register"),
        centerTitle:true,
        actions: <Widget>[
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
              Container(
              padding: EdgeInsets.fromLTRB(60.0, 25.0, 55.0, 0.0),
            ),
              Container(
                margin: const EdgeInsets.only(top: 70),
                  child: TextFormField(
                controller: userid,
                decoration: InputDecoration(
                  labelText: "User Id",
                  hintText: "User Id",
                ),
                validator: (value) {
                  if (value.isEmpty) return "โปรดกรอก User Id";
                  if (value.length < 6 || value.length > 12)
                    return "User Id ไม่ถูกต้อง";
                },
              )
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                ),
                validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "โปรดกรอก User Id";
                  for (int i = 0; i < value.length; i++) {
                    if (value[i] == " ") {
                      count = 1;
                    }
                  }
                  if (count == 0) {
                    return "Name ไม่ถูกต้อง";
                  }
                },
              )
              ),
              
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child:  TextFormField(
                controller: age,
                decoration: InputDecoration(
                  labelText: "Age",
                ),
                validator: (value) {
                  if (value.isEmpty) return "โปรดกรอกอายุ";
                  if (value.isEmpty || int.parse(value) < 10 || int.parse(value) > 80)
                    return "Age ไม่ถูกต้อง";
                },
              )
              ),

                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty && value.length < 6)
                    return "Password ไม่ถูกต้อง";
                },
              )
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    child: Text('REGISTER NEW ACCOUNT'),
                    splashColor: Colors.blue,
                    onPressed: () {
                        bool check = true;
                        if (_formkey.currentState.validate()) {
                          if (currentUsers.length == 0) {
                            User user = User(
                                userid: userid.text,
                                name: name.text,
                                age: age.text,
                                password: password.text);
                            userProvider.insert(user).then((r) {
                              Navigator.pushReplacementNamed(context, '/');
                            });
                          } else {
                            for (int i = 0; i < currentUsers.length; i++) {
                              if (userid.text == currentUsers[i].userid) {
                                check = false;
                                break;
                              }
                            }
                            if (check) {
                              User user = User(
                                  userid: userid.text,
                                  name: name.text,
                                  age: age.text,
                                  password: password.text);
                              userProvider.insert(user).then((r) {
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'มีรหัสนี้อยู่แล้ว'),
                                    );
                                  });
                            }
                          }
                        }
                      },
                  )),
            ])),
      ),
    );
  }

 
}
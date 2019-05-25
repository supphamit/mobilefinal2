import 'package:flutter/material.dart';
import 'register.dart';
import 'home.dart';
import 'model/user.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginpageState createState() {
    return LoginpageState();
  }
}
int count = 0;


class LoginpageState extends State<Login> {
   final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();
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


  SharedPreferences prefs;

   @override
   
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Login"),
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
              child: Image.asset(
                "resources/bg.jpg", height: 200, width: 200,
              ),
              padding: EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 0.0),
            ),
              Container(
                  child: TextFormField(
                controller: userid,
                decoration: InputDecoration(
                  labelText: "Userid",
                ),
                validator: (value) {
                  if (value.isEmpty) return "๊Username ไม่ถูกต้อง";
                },
              )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) return "Password is required";
                },
              )),
               Container(
                    child: RaisedButton(
                      child: Text("sign in"),
                      onPressed: () async{
                        if (_formkey.currentState.validate()) {
                          for (int i = 0; i < currentUsers.length; i++) {
                            if (userid.text == currentUsers[i].userid &&
                                password.text == currentUsers[i].password) {
                                  count += 1;
                                  prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('name', currentUsers[i].name);
                                  
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Homepage(user: currentUsers[i]),
                                ),
                              );
                            }
                            
                        
                          }
                        if(count == 0) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'Invalid user or password'),
                                    );
                                  });
                            }
                        }
                      },
                      
                    ),
                
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      'Register New Account',
                      style: TextStyle(color: Colors.teal),
                    ),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Register(), ),);
                    },
                  ))
            ])),
      ),
    );
  }

 
}
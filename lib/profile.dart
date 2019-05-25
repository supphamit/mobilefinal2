import 'package:flutter/material.dart';
import 'model/user.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  final User user;
  Profilepage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ProfilepageState();
  }
}

class ProfilepageState extends State<Profilepage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController quote = TextEditingController();
  UserProvider userProvider = UserProvider();

SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    userProvider.open('member.db').then((r) {
    });
  }

  @override
  Widget build(BuildContext context) {
    User myuser = widget.user;
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: userid,
                  decoration: InputDecoration(labelText: "User Id"),
                  validator: (value) {
                    if (value.length < 6 || value.length > 12)
                      return "Userid ไม่ถูกต้อง";
                  },
                ),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                  ),
                  validator: (value) {
                    int count = 0;
                    for (int i = 0; i < value.length; i++) {
                      if (value[i] == " ") {
                        count = 1;
                      }
                    }
                    if (count == 0) {
                      return "ชื่อ ไม่ถูกต้อง";
                    }
                  },
                ),
                TextFormField(
                  controller: age,
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                  validator: (value) {
                    if (value.isEmpty || int.parse(value) < 10 || int.parse(value) > 80)
                      return "อายุ ต้องเป็นตัวเลข";
                  },
                ),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.length < 6) return "Password ไม่ถูกต้อง";
                  },
                ),
                TextFormField(
                  controller: quote,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Quote"),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: ()async {
                          final prefs = await SharedPreferences.getInstance();
                          if (_formkey.currentState.validate()) {
                            if (userid.text != Null) {
                              myuser.userid = userid.text;
                            }
                            if (name != Null) {
                              myuser.name = name.text;
                            }
                            if (age.text != Null) {
                              myuser.age = age.text;
                            }
                            if (password.text != Null) {
                              myuser.password = password.text;
                            }
                            if (quote.text != Null) {
                              myuser.quote = quote.text;
                            }
                                  await SharedPreferences.getInstance();
                                  await prefs.setString('name', name.text);
                            userProvider.updateUser(myuser).then((r) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Homepage(user: myuser),
                                ),
                              );
                            });
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
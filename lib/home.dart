import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'login.dart';
import 'profile.dart';
import 'friend.dart';
import 'model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Homepage extends StatefulWidget {
  final User user;
  Homepage({Key key, this.user}) : super(key: key);
  @override
  HomepageState createState() {
    // TODO: implement createState
    return HomepageState();
  }
}

class HomepageState extends State<Homepage> {
  SharedPreferences prefs;
  String name= "";
  
  @override
  void initState() {
    super.initState();
    readLocal();
  }
  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name' ?? '');

    // Force refresh input
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    User user = widget.user;
    return Scaffold(
      appBar:AppBar(
        title:Text("Home"),
        centerTitle:true,
        actions: <Widget>[
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
                  title: Text(
                    "Hello  $name",
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text('this is my quote  "${user.quote}"'),
                ),
            
            RaisedButton(
                  child: Text("PROFILE SETUP"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profilepage(user: user),
                      ),
                    );
                  },

                ),
            RaisedButton(
                  child: Text("MY FRIENDS"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Friendpage(user: user),
                      ),
                    );
                  },
                ),
           RaisedButton(
                    child: Text('SIGN OUT'),
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      await pref.clear();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
          ] 
        ),
      ),
      
    );
  }
}
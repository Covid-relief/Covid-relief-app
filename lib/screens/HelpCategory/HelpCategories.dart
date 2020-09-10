import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/HelpCategory/PersonalizedHelp.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';


class Category extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
 // State<StatefulWidget> createState() {
    Widget build(BuildContext context) {

      return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Covid Relief', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 25),),
              backgroundColor: Colors.lightBlue[900],
              elevation: 0.0,),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[900],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Inicio',),
                  onTap: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
                //FlatButton.icon(
                //  icon : Icon(Icons.settings),
                // label: Text("Configuración"),
                // onPressed:() => _showSettingsPanel(),
                // ),

                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Cerrar Sesión'),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()),);
                  },
                ),
              ],
            ),
          ),
            body:
            ListView(
              padding: const EdgeInsets.all(15),
              children: <Widget>[
                Container(
                  height: 90,
                  child: const Center(child: Text('Categorías de ayuda', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.teal[200],
                    onPressed:() async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help()),);
                    },
                    child: new Text("Business", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.teal[200],
                    onPressed:() {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help()),);
                    },
                    child: new Text("Tecnología", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.teal[200],
                    onPressed:() async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help()),);
                    },
                    child: new Text("Medicina", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.teal[200],
                    onPressed:() async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help()),);
                    },
                    child: new Text("Psicología", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 40,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(50,0,50,0),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Para comunicarte con la facultad de medicina UFM, '
                            'llama al siguiente número', textAlign: TextAlign.center,),
                        RichText(text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.phone)),
                              TextSpan(
                                text: '  2413 3235',
                                style: TextStyle(color: Colors.black),
                              )
                            ]
                        ))
                      ],
                    )
                )
              ],
            )
          // personal data from settings_form.dart
          //HAY QUE DESARROLLAR EL HOME
          // redirect to user profile
          //UserProfile(), //UserList(),

      );
    }
  }






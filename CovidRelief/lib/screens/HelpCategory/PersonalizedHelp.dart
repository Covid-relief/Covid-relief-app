import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget{
  final AuthService _auth = AuthService();

    @override
    // State<StatefulWidget> createState() {
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('CovidRelief'),
            backgroundColor: Colors.red[400],
            elevation: 0.0,),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
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
                child: const Center(child: Text('¿Cómo deseas ayudar?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              Container(
                height: 50,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50,0,50,0),
                child:
                RaisedButton(
                  padding: const EdgeInsets.all(2.0),
                  textColor: Colors.white,
                  color: Colors.orangeAccent[700],
                  onPressed:() async {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ),);
                  },
                  child: new Text("Tips y consejos generales"),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50,0,50,0),
                child:
                RaisedButton(
                  padding: const EdgeInsets.all(2.0),
                  textColor: Colors.white,
                  color: Colors.orangeAccent[700],
                  onPressed:() {
                  },
                  child: new Text("Apoyo personalizado y contacto personal"),
                ),
              ),
              Container(
                height: 90,
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
                  ),
              ),
            ],
          )
      );
  }
}
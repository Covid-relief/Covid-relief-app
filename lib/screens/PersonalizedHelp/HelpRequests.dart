import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:CovidRelief/models/user.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class HelpRequests extends StatefulWidget {
  String categoryOfHelp;
  HelpRequests({this.categoryOfHelp});
  
  @override
  _HelpRequestsState createState() {
    return _HelpRequestsState(categoryOfHelp:categoryOfHelp);
  }
}

class _HelpRequestsState extends State<HelpRequests>{
  final AuthService _auth = AuthService();

  String categoryOfHelp;
  _HelpRequestsState({this.categoryOfHelp});

  final databaseReference = Firestore.instance;
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String uid = user.uid;
    return StreamBuilder(
      stream: Firestore.instance.collection("darayuda").where("category", isEqualTo: categoryOfHelp).where("uid", isEqualTo: uid).snapshots(),
      builder: (context, snapshot) {
        DocumentSnapshot helpGiver = snapshot.data.documents[0];
        return Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
              flexibleSpace: Container(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          const Color(0xFFFF5252),
                          const Color(0xFFFF1744)
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 0.5],
                        tileMode: TileMode.clamp
                      ),
                    ),
                  ),
              title: Text(
                'Covid Relief',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 25),
              ),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.redAccent[400],
                      ),
                      child: Text(
                        'Covid Relief', 
                        style: TextStyle(
                          height: 5.0,
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      'Inicio',
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      'Perfil',
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfile()),
                      );
                    },
                  ),

                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Cerrar Sesión'),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // agregar momento de carga
            body: StreamBuilder(
              stream: Firestore.instance.collection('solicitarayuda').where("state", isEqualTo: "unattended").where("category", isEqualTo: categoryOfHelp).snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myPost = snapshot.data.documents[index];
                    return pendingRequests(
                      myPost['category'], 
                      myPost['code'],
                      myPost['contactMail'], 
                      myPost['contactMessage'],
                      myPost['description'], 
                      myPost['email'],
                      myPost['name'], 
                      myPost['phone'],
                      helpGiver['name'],
                      helpGiver['phone'],
                      helpGiver['email'],
                    );
                  }
                );
              },
            )
        );
      }
    );}
  }
  _sendEmail(String receiver, String sub, String message, String helper, String helperNumber, String helperMail, int code) async {
    String mess= "¡Hola!\n\nMi nombre es $helper\nMe gustaría ayudarte con tu petición de ayuda:\n\n $message\n";
    if(helperNumber!=null){
      mess+="\nMi número es $helperNumber";
    }
    if(helperMail!=null){
      mess+="\nMi correo es $helperMail";
    }
    mess+="\n\nTu código para evaluar esta ayuda es $code\n\nSaludos cordiales";
    final String _email = 'mailto:' +
        receiver +
        '?subject=' +
        "Ayuda para tu caso de "+ sub +
        '&body=' +
        mess;
    try {
      await launch(_email);
    } catch (e) {
      throw e.toString();
    }
  }

  _sendWhatsapp(String phone, String cat, String message, String helper, String helperNumber, String helperMail, int code){
    String mess= "¡Hola!\n\nMi nombre es $helper\nMe gustaría ayudarte con tu petición de ayuda en $cat:\n\n $message\n";
    if(helperNumber!=null){
      mess+="\nMi número es $helperNumber";
    }
    if(helperMail!=null){
      mess+="\nMi correo es $helperMail";
    }
    mess+="\n\nTu código para evaluar esta ayuda es $code\n\nSaludos cordiales";

    if(phone.substring(0)=='+'){
      return FlutterOpenWhatsapp.sendSingleMessage(phone, mess);
    }
    if(phone.length > 8){
      return FlutterOpenWhatsapp.sendSingleMessage(phone.substring(3), mess);
    }
    return FlutterOpenWhatsapp.sendSingleMessage('+502$phone', mess);
  }

  Widget pendingRequests(String category, int code, bool contactMail, bool contactMessage, String description, String email, String name, String phone, String helpGiverName, String helpGiverNumber, String helpGiverMail){
    // marcar caso como atendido
    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Flexible(
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: TextStyle(height: 2.0),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  onPressed: ()=>_sendEmail(email, category, description, helpGiverName, helpGiverNumber, helpGiverMail, code),
                  child: Text("Enviar correo"),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  shape: StadiumBorder(),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  onPressed: ()=> _sendWhatsapp(phone, category, description, helpGiverName, helpGiverNumber, helpGiverMail, code),
                  child: Text("Enviar whatsapp"),
                  textColor: Colors.white,
                  color: Colors.green[300],
                  shape: StadiumBorder(),
                )
              ],
            )
          ],
        ),
      )
    );
}
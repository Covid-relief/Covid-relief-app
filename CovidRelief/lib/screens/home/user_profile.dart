import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/services/database.dart';

class UserProfile extends StatelessWidget {

@override
  Widget build(BuildContext context) {
 
    final AuthService _auth = AuthService();

    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);

    return new StreamBuilder(
      // here we get the info from the document of the collection of the user
      stream: Firestore.instance.collection('perfiles').document(user.uid).snapshots(),
      builder: (context, snapshot) {

        // if there is no data in the collection display "No data". This should never occur
        if (!snapshot.hasData) {
          print('No data');
        }
        // we use this variable to display info from the user
        var userData = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Perfil'),
            backgroundColor: Colors.red[400],
            actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()),);
                },
              ),
            ],
          ),
          body: Center(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  // Circle for profile picture
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.red[900]
                    ),
                    SizedBox(height: 20.0),
                    // Diplay name
                    Text(
                      userData['name'],
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    // Diplay country
                    Text(
                      userData['country'],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 50.0),
                  // Display more data
                  ListTile(
                    title: Text('Datos personales'),
                  ),
                  // here we make a table with four rows and two columns to organize the data
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 70, 0),
                            child: Text(userData['phone']),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 70, 0),
                            child: Text(
                              'Telefono',
                              style: TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 20, 0),
                            child:Text(
                              userData['birthday'].substring(8, 10) + ' / ' + userData['birthday'].substring(5, 7) + ' / ' + userData['birthday'].substring(0, 4)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 20, 0),
                            child: Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // second pair of data
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 70, 0),
                            child: Text(userData['type']),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 70, 0),
                            child: Text(
                              'Tipo de perfil',
                              style: TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 20, 20, 0),
                            child: Text(userData['gender']),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 20, 0),
                            child: Text(
                              'Genero',
                              style: TextStyle(
                                color: Colors.grey
                              )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ),
          ),
        );
      } // builder
    );
  }
}
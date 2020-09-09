import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';


import 'components/contact_card.dart';
import 'constants.dart';

class NearbyInterface extends StatefulWidget {
  static const String id = 'nearby_interface';

  @override
  _NearbyInterfaceState createState() => _NearbyInterfaceState();
}

class _NearbyInterfaceState extends State<NearbyInterface> {
  Location location = Location();
  Firestore _firestore = Firestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  FirebaseUser loggedInUser;
  String testText = '';
  final _auth = FirebaseAuth.instance;
  List<dynamic> contactTraces = [];
  List<dynamic> contactTimes = [];
  List<dynamic> contactLocations = [];

  void addContactsToList() async {
    await getCurrentUser();

    _firestore
        .collection('perfiles')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
        String currUsername = doc.data['name'];
        DateTime currTime = doc.data.containsKey('contact time')
            ? (doc.data['contact time'] as Timestamp).toDate()
            : null;
        String currLocation = doc.data.containsKey('contact location')
            ? doc.data['contact location']
            : null;

        if (!contactTraces.contains(currUsername)) {
          contactTraces.add(currUsername);
          contactTimes.add(currTime);
          contactLocations.add(currLocation);
        }
      }
      setState(() {});
      print(loggedInUser.email);
    });
  }

  void deleteOldContacts(int threshold) async {
    await getCurrentUser();
    DateTime timeNow = DateTime.now(); //get today's time

    _firestore
        .collection('perfiles')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
//        print(doc.data.containsKey('contact time'));
        if (doc.data.containsKey('contact time')) {
          DateTime contactTime = (doc.data['contact time'] as Timestamp)
              .toDate(); // get last contact time
          // if time since contact is greater than threshold than remove the contact
          if (timeNow.difference(contactTime).inDays > threshold) {
            doc.reference.delete();
          }
        }
      }
    });

    setState(() {});
  }

  void discovery() async {
    try {
      bool a = await Nearby().startDiscovery(loggedInUser.email, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an email

        var docRef =
            _firestore.collection('perfiles').document(loggedInUser.email);

        //  When I discover someone I will see their email and add that email to the database of my contacts
        //  also get the current time & location and add it to the database
        docRef.collection('met_with').document(name).setData({
          'name': await getUsernameOfEmail(email: name),
          'contact time': DateTime.now(),
          'contact location': (await location.getLocation()).toString(),
        });
      }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  Future<String> getUsernameOfEmail({String email}) async {
    String res = '';
    await _firestore.collection('perfiles').document(email).get().then((doc) {
      if (doc.exists) {
        res = doc.data['name'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    deleteOldContacts(14);
    addContactsToList();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('Contact Trace'),
            backgroundColor: Colors.cyan[700],
              /*
              actions: <Widget> [
                FlatButton.icon(
                  icon : Icon(Icons.settings),
                  label: Text("Configuración"),
                  onPressed:() {},
                ),
              ],
              */
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.cyan[700],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 10.0,
                top: 30.0,
              ),
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Image(
                        image: AssetImage('images/corona.png'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Your Contact Traces',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 5.0,
              color: Colors.blue[300],
              onPressed: () async {
                try {
                  bool a = await Nearby().startAdvertising(
                    loggedInUser.email,
                    strategy,
                    onConnectionInitiated: null,
                    onConnectionResult: (id, status) {
                      print(status);
                    },
                    onDisconnected: (id) {
                      print('Disconnected $id');
                    },
                  );

                  print('ADVERTISING ${a.toString()}');
                } catch (e) {
                  print(e);
                }

                discovery();
              },
              child: Text(
                'Start Tracing',
                style: kButtonTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ContactCard(
                    imagePath: 'images/profile1.jpg',
                    email: contactTraces[index],
                    infection: 'Not-Infected',
                    contactUsername: contactTraces[index],
                    contactTime: contactTimes[index],
                    contactLocation: contactLocations[index],
                  );
                },
                itemCount: contactTraces.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Take mobile number instead of email

// TODO: Delete contacts older than 14 days from database

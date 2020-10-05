import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GivePersonalizedHelp extends StatefulWidget {
  String categoryOfHelp;
  GivePersonalizedHelp({this.categoryOfHelp});
  
  @override
  _GivePersonalizedHelpState createState() {
    return _GivePersonalizedHelpState(categoryOfHelp:categoryOfHelp);
  }
}

class _GivePersonalizedHelpState extends State<GivePersonalizedHelp>{
  String categoryOfHelp;
  _GivePersonalizedHelpState({this.categoryOfHelp});

  String _formName;
  String _formEmail;
  String _formPhone;
  bool _contactMail=false;
  bool _contactMessage=false;

  final databaseReference = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
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
        title: Text('Apoyar en ' + categoryOfHelp),
        //backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: _buildForm()
      )
    );
  }

// _buildForm()
  // APP LAYER?
  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(height: 30.0,),
        _buildDisclaimer(),
        SizedBox(height: 30.0,),
        _buildNameField(),
        SizedBox(height: 25.0,),
        _buildEmailField(),
        SizedBox(height: 25.0,),
        _buildPhoneField(),
        SizedBox(height: 25.0,),
        _buildContactMail(),
        _buildContactMessage(),
        SizedBox(height: 15.0,),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de las solicitudes e ideas aquí presentadas '
        'y el éxito o fracaso de las mismas.',
        textAlign: TextAlign.center
      )
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Nombre completo',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
        ),
        validator: (valname) => valname.isEmpty ? 'Por favor ingrese su nombre' : null,
        onChanged: (valname) => setState(() => _formName = valname),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
        ),
        validator: (val) => val.isEmpty ? 'Ingrese un correo electrónico válido' : null,
        onChanged: (valemail) => setState(() => _formEmail = valemail),
      ),
    );
  }


  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Número de teléfono',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
        ),
        validator: (valphone) => valphone.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valphone) => setState(() => _formPhone = valphone),
      ),
    );
  }

  Widget _buildContactMail() {
      return CheckboxListTile(
        title: Text("Contactarme por correo"),
        value: _contactMail,
        onChanged: (mailCont) => setState(() => _contactMail = mailCont),
        controlAffinity: ListTileControlAffinity.leading,
      );
  }
  Widget _buildContactMessage() {
      return CheckboxListTile(
        title: Text("Contactarme por mensaje"),
        value: _contactMessage,
        onChanged: (messageCont) => setState(() => _contactMessage = messageCont),
        controlAffinity: ListTileControlAffinity.leading,
      );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(70,0,70,0),
      child:
        RaisedButton(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          color: Colors.blueAccent,
          shape: StadiumBorder(),
          onPressed: () {
            print(_formName);
            print(_formKey);
            print(_formEmail);
            print(_formPhone);
            //_submitForm(); aun no se usara
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);},
          child: Text('Empezar a apoyar', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
    );

  }

  void _submitForm() async {
    DocumentReference ref = await databaseReference.collection("darayuda_" + categoryOfHelp)
        .add({
          'email': _formEmail,
          'name': _formName,
          'phone': _formPhone
        });
    print(ref.documentID);
  }
}
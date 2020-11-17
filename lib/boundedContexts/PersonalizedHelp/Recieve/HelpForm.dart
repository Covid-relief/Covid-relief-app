import 'package:CovidRelief/boundedContexts/home/home.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class HelpForm extends StatefulWidget {
  String categoryOfHelp;
  HelpForm({this.categoryOfHelp});
  
  @override
  HelpFormState createState() {
    return HelpFormState(categoryOfHelp:categoryOfHelp);
  }
}

class HelpFormState extends State<HelpForm>{
  String categoryOfHelp;
  HelpFormState({this.categoryOfHelp});

  String _formName;
  String _formEmail;
  String _formPhone;
  String _formDescription;

  final databaseReference = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  // popup para avisar que el post estara solo 10 dias arriba y se actualizara con interacciones
  openPopup(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text('Tu solicitud se publicará anónimamente durante 10 días en el tablero de ayuda personalizada. '+
                        'Si tu solicitud tiene interacciones se extenderá el tiempo de publicación para mantenerla activa'),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  _submitForm();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                },
              ),
            ],
        );
      });
  }
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
        title: Text('Solicitud de apoyo personal'),
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
    return Form(
      key: _formKey,
      child: Column(
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
          _buildProblemField(),
          SizedBox(height: 15.0,),
          _buildSubmitButton(),
        ],
      )
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
        'y el éxito o fracaso de los mismos.',
        textAlign: TextAlign.center
        ),
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

  Widget _buildProblemField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Describe brevemente tu problema',
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
        validator: (valdescription) => valdescription.isEmpty ? 'Por favor ingrese su problema' : null,
        onChanged: (valdescription) => setState(() => _formDescription = valdescription),
      ),
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
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              openPopup();
            }            
          },
          child: Text('Enviar Solicitud',style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
    );
  }

  void _submitForm() async {
    
    Random random = new Random();
    int code = random.nextInt(99999 - 10000);

    DocumentReference ref = await databaseReference.collection("solicitarayuda")
        .add({
          'state': 'unattended',
          'category':categoryOfHelp,
          'name': _formName,
          'description': _formDescription,
          'email': _formEmail,
          'phone': _formPhone,
          'code': code,
          'lastInteraction': DateTime.now(),
          'rating' : -1
        });
    print(ref.documentID);
  }
}
import 'package:CovidRelief/models/forms.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpForm extends StatefulWidget {
  @override
  HelpFormState createState() {
    return HelpFormState();
  }
}

class HelpFormState extends State<HelpForm>{

  String _formName;
  String _formEmail;
  String _formPhone;
  String _formDescription; // not displaying in the app

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de apoyo personalizado'),
      ),
      body:
      _buildForm()
    );
  }

// _buildForm()
  // APP LAYER?
  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildDisclaimer(),
        _buildNameField(),
        _buildEmailField(),
        _buildPhoneField(),
        _buildProblemField(),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
        'y el éxito o fracaso de los mismos.',
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Nombre completo'),
        validator: (valname) => valname.isEmpty ? 'Por favor ingrese su nombre' : null,
        onChanged: (valname) => setState(() => _formEmail = valname),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
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
        decoration: InputDecoration(labelText: 'Número de teléfono'),
        validator: (valphone) => valphone.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valphone) => setState(() => _formPhone = valphone),
      ),
    );
  }

  Widget _buildProblemField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Describe brevemente tu problema'),
        validator: (valdescription) => valdescription.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valdescription) => setState(() => _formDescription = valdescription),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {_submitForm();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);},
      child: Text('Enviar Solicitud'),
    );
  }

  void _submitForm() async {
    if(_formKey.currentState.validate()){
      await Firestore.instance.collection('solicitarayuda').add({'description':_formDescription,'email':_formEmail, 'name':_formName, 'phone':_formPhone,});
    }
  }

}
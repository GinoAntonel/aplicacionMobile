import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quit Smoking'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_alert),
                tooltip: 'Show ',
                onPressed: () {
                }),
            IconButton(
              icon: Icon(Icons.android),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final database = FirebaseDatabase.instance.reference();
  TextEditingController _nombre = new TextEditingController();
  TextEditingController _apellido = new TextEditingController();
  TextEditingController _cantidad = new TextEditingController();
  TextEditingController _precio = new TextEditingController();
  TextEditingController _fecha = new TextEditingController();

  var fecha = new DateTime.now();
  var dateFormat = DateFormat("yMd");



  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _subscription = database.onValue.listen((data) {
      String valueName = data.snapshot.value as String ?? "";
      String valueA = data.snapshot.value as String ?? "";
      double valueC = data.snapshot.value as double;
      double valueP = data.snapshot.value as double;
      String strDate = dateFormat.format(fecha).toString();
    });
  }

  saveOnChanged(String valueName, String valueA, double valueC, double valueP, String strDate) async {
    await database.set({
      'nombre': valueName,
      'apellido': valueA,
      'cantidad': valueC,
      'precio': valueP,
      'fecha': strDate,
    });  
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: TextFormField(
              controller: _nombre,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no puede estar vacio';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: TextFormField(
              controller: _apellido,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Apellido',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no puede estar vacio';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: TextFormField(
              controller: _cantidad,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cantidad de paquetes por dia',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no puede estar vacio';
                }
                return null;  
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: TextFormField(
              controller: _precio,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Precio por paquete',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no puede estar vacio';
                }else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyWidget()),
                  );
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var nombre = _nombre.text;
                  var apellido = _apellido.text;
                  double cantidad = double.parse(_cantidad.value.text);
                  double precio = double.parse(_precio.value.text);
                  DateTime fechaF = new DateTime.now();
                  saveOnChanged(nombre, apellido, cantidad, precio, fechaF.toString());
                }
              },
              child: Text('Empezar'),
            ),
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  MyWidget({Key key}) : super(key: key);

  @override
  _MyWidget createState() => _MyWidget();
}

class _MyWidget extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Container(
                child: (
                Row(
                  children: <Widget>[
                    Text(
                    'Hello, d How are you?',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
                )
              ),

              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
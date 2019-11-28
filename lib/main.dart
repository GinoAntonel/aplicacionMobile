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

  
  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _subscription = database.onValue.listen((data) {
      String valueName = data.snapshot.value as String ?? "";
      String valueA = data.snapshot.value as String ?? "";
      double valueC = data.snapshot.value as double;
      double valueP = data.snapshot.value as double;
      double valuePq = data.snapshot.value as double;
    });
  }

  saveOnChanged(String valueName, String valueA, double valueC, double valueP, valuePq) async {
    await database.set({
      'nombre': valueName,
      'apellido': valueA,
      'cantidad': valueC,
      'precio': valueP,
      'fecha': DateTime.now().toString(),
      'paquete': valuePq,
    });
  }

  bool tenSelected = false;
  bool twSelected = false;

  @override
  Widget build(BuildContext context) {
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
          Column(
            children: [
              Divider(),
              Text('Tamanio de la etiqueta'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 30.0),
                        label: Text("10"),
                        selected: tenSelected,
                        onSelected: (selected) {
                          if (tenSelected == false) {
                            setState(() {
                              tenSelected = true;
                              twSelected = false;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 30.0),
                        label: Text("20"),
                        selected: twSelected,
                        onSelected: (selected) {
                          if (twSelected == false) {
                            setState(() {
                              twSelected = true;
                              tenSelected = false;
                            });
                          }
                        }),
                  ),
                ]),
              ),
              Divider(),
            ],
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
                } else {
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
                  var valuePq = tenSelected ? 10 : 20;
                  saveOnChanged(nombre, apellido, cantidad, precio, valuePq);
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
StreamSubscription _subscription;
final database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 5.0, color: Colors.greenAccent[400]),
              ),
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.error)),
              ],
            ),
            title: Text('Quit Smoking'),
          ),
          body: TabBarView(
            children: [
              Container(
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        Container(
                            padding: EdgeInsets.only(
                                right: 5, left: 5, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: MyCard()),
                        Container(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: TimeCard(),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Probando(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              MyEdit()
            ],
          ),
        ),
      ),
    );
  }
}

class MyEdit extends StatefulWidget {
  @override
  editForm createState() {
    return editForm();
  }
}

class editForm extends State<MyEdit> {
  TextEditingController myController = new TextEditingController();
  TextEditingController controllerApellido = new TextEditingController();
  TextEditingController controllerCantidad = new TextEditingController();
  TextEditingController controllerPrecio = new TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  final _formKey = GlobalKey<FormState>();
  StreamSubscription _subscription;

  _agregar(nombre, apellido, cantidad, precio, paquete) async {
    databaseReference.update({
      'nombre': nombre,
      'apellido': apellido,
      'cantidad': cantidad,
      'precio': precio,
      'paquete': paquete,
    });
  }

  _updateFecha() async {
    databaseReference.update({'fecha': DateTime.now().toString()});
  }

  bool tenSelected = false;
  bool twSelected = false;

  bool resetValue = false;

  void initState() {
    super.initState();
  

    databaseReference.once().then((DataSnapshot snapshot) {
      String nombre = snapshot.value['nombre'] as String ?? "";
      String apellido = snapshot.value['apellido'] as String ?? "";
      int cantidad = snapshot.value['cantidad'] as int;
      int precio = snapshot.value['precio'] as int;
      int paquete = snapshot.value['paquete'] as int;

      if (paquete == 10) {
        tenSelected = true;
      } else {
        twSelected = true;
      }

      setState(() {
        myController..text = nombre;
        controllerApellido..text = apellido;
        controllerCantidad..text = cantidad.toString();
        controllerPrecio..text = precio.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixText: 'Nombre',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                    ),
                    prefixIcon: Padding(
                      child: IconTheme(
                        data: IconThemeData(
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.person),
                      ),
                      padding: EdgeInsets.only(left: 30, right: 10),
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: TextFormField(
                controller: controllerApellido,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixText: 'Apellido',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                    ),
                    prefixIcon: Padding(
                      child: IconTheme(
                        data: IconThemeData(
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.person),
                      ),
                      padding: EdgeInsets.only(left: 30, right: 10),
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: TextFormField(
                controller: controllerCantidad,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixText: 'Cantidad de paquetes',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                    ),
                    prefixIcon: Padding(
                      child: IconTheme(
                        data: IconThemeData(
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.view_carousel),
                      ),
                      padding: EdgeInsets.only(left: 30, right: 10),
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: TextFormField(
                controller: controllerPrecio,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixText: 'Precio',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                    ),
                    prefixIcon: Padding(
                      child: IconTheme(
                        data: IconThemeData(
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.attach_money),
                      ),
                      padding: EdgeInsets.only(left: 30, right: 10),
                    )),
              ),
            ),
            Column(
              children: [
                Divider(),
                Text('Tamanio de la etiqueta'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 1.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 30.0),
                              label: Text("10"),
                              selected: tenSelected,
                              onSelected: (selected) {
                                if (tenSelected == false) {
                                  setState(() {
                                    tenSelected = true;
                                    twSelected = false;
                                  });
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 30.0),
                              label: Text("20"),
                              selected: twSelected,
                              onSelected: (selected) {
                                if (twSelected == false) {
                                  setState(() {
                                    twSelected = true;
                                    tenSelected = false;
                                  });
                                }
                              }),
                        ),
                      ]),
                ),
                Divider(),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Meti la pata y fume..."),
                    Checkbox(
                      value: resetValue,
                      onChanged: (bool value) {
                        setState(() {
                          resetValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      highlightElevation: 10.0,
                      splashColor: Colors.blue,
                      highlightColor: Colors.white,
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 3),
                          borderRadius: new BorderRadius.circular(
                            30.0,
                          )),
                      child: Text(
                        'Editar',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          var nombre = myController.text;
                          var apellido = controllerApellido.text;
                          int cantidad =
                              int.parse(controllerCantidad.value.text);
                          int precio = int.parse(controllerPrecio.value.text);
                          var paquete = tenSelected ? 10 : 20;

                          if (resetValue == true) {
                            _updateFecha();
                          }
                          _agregar(nombre, apellido, cantidad, precio, paquete);
                        }
                      },
                    ),
                  ),
                )),
          ],
        ),
      ]),
    );
  }
}

class MyCard extends StatefulWidget {
  MyCard({Key key}) : super(key: key);

  @override
  _MyCard createState() => _MyCard();
}

class _MyCard extends State<MyCard> {
  final database = FirebaseDatabase.instance.reference();
  var nombre;
  var fecha;
  var diferencia;
  var tiempo;
  Timer timer;

  void calculateDiference() {
    database.once().then((DataSnapshot snapshot) {
      setState(() {
        nombre = snapshot.value['nombre'];
        fecha = DateTime.parse(snapshot.value['fecha']);
        tiempo = DateTime.now();
        diferencia = tiempo.difference(fecha);
      });
    });
  }

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    calculateDiference();
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          padding: EdgeInsets.only(bottom: 16, top: 16),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.lightGreen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    "assets/images/time.png",
                    width: 70,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Text(
                  diferencia.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TimeCard extends StatefulWidget {
  TimeCard({Key key}) : super(key: key);

  @override
  _TimeCard createState() => _TimeCard();
}

class _TimeCard extends State<TimeCard> {
  final database = FirebaseDatabase.instance.reference();
  var cantidad;
  Timer timer;
  var fecha;
  var diferencia = 1;
  var paquete;
  var cigarrillos = 0;
  double ahorro = 0;

  void calculateC() {
    database.once().then((DataSnapshot snapshot) {
      fecha = DateTime.parse(snapshot.value['fecha']);
      cantidad = snapshot.value['cantidad'];
      paquete = snapshot.value['paquete'];
      setState(() {
        if (DateTime.now().difference(fecha).inHours >= diferencia) {
          diferencia += 1;
          cigarrillos = paquete * cantidad;
          ahorro += cigarrillos / 24;
        }
      });
    });
  }

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => calculateC());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.lightGreen),
          padding: EdgeInsets.only(bottom: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    "assets/images/stop-smoking.png",
                    width: 70,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Text(
                  'Cigarrillos no fumados: ' + ahorro.toStringAsFixed(0),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Probando extends StatefulWidget {
  Probando({Key key}) : super(key: key);

  @override
  _Probando createState() => _Probando();
}

class _Probando extends State<Probando> {
  final database = FirebaseDatabase.instance.reference();
  var precio;
  var cantidad;
  double ahorro = 0;
  Timer timer;
  var fecha;
  var diferencia = 60;
  var sumar;
  String s = "\$";

  void calculateSave() {
    database.once().then((DataSnapshot snapshot) {
      fecha = DateTime.parse(snapshot.value['fecha']);
      precio = snapshot.value['precio'];
      cantidad = snapshot.value['cantidad'];
      setState(() {
        sumar = (precio * cantidad) / 24;
        if (DateTime.now().difference(fecha).inMinutes >= diferencia) {
          diferencia += 60;
          ahorro += sumar;
        }
      });
    });
  }

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => calculateSave());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.lightGreen),
          padding: EdgeInsets.only(bottom: 11, top: 11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    "assets/images/ahorrar.png",
                    width: 70,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen),
                padding: EdgeInsets.all(10),
                child: Text(
                  'Dinero ahorrado: ' + ahorro.toStringAsFixed(0) + ' $s',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

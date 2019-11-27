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
  var dateFormat = DateFormat("Hms");



  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _subscription = database.onValue.listen((data) {
      String valueName = data.snapshot.value as String ?? "";
      String valueA = data.snapshot.value as String ?? "";
      double valueC = data.snapshot.value as double;
      double valueP = data.snapshot.value as double;
      String strDate = dateFormat.format(fecha).toString();
      double valuePq = data.snapshot.value as double;
    });
  }

  saveOnChanged(String valueName, String valueA, double valueC, double valueP, String strDate,valuePq) async {
    await database.set({
      'nombre': valueName,
      'apellido': valueA,
      'cantidad': valueC,
      'precio': valueP,
      'fecha': strDate,
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
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip( 
                      labelPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      label: Text("10"),
                      selected: tenSelected,
                      onSelected: (selected) {
                        if (tenSelected == false){
                          setState(() {
                            tenSelected = true;
                            twSelected = false;
                          });
                        }
                      } 
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip( 
                      labelPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      label: Text("20"),
                      selected: twSelected,
                      onSelected: (selected) {
                        if (twSelected == false){
                          setState(() {
                            twSelected = true;
                            tenSelected = false;
                          });
                        }
                      } 
                    ),
                  ),
                  ]
         ),
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
                  var valuePq = tenSelected ? 10 : 20;
                  saveOnChanged(nombre, apellido, cantidad, precio, fechaF.toString(), valuePq);
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
            backgroundColor: Colors.green,
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 5.0,
                  color: Colors.greenAccent[400]
                ),
              ),
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
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
                        Container (
                          padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0)),
                          child: MyCard()
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0)),
                          child: TimeCard(),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0)),
                          child: Probando (),
                        )
                      ],
                    ),
                  ),
                ),
                
              ),
              StepperPage(),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class StepperPage extends StatefulWidget {
  @override
  _StepperState createState() => _StepperState();
}

class _StepperState extends State<StepperPage> {

  final database = FirebaseDatabase.instance.reference();
  final _nombre = new TextEditingController();

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _subscription = database.onValue.listen((data) {
      String valueNombre = data.snapshot.value as String ?? "";
    });
  }

  saveOnChanged(String valueNombre) async {
    await database.set({
      'nombre': valueNombre,
    });  
  }
  List<Step> steps = [

    Step(
      title: const Text('Nombre y Apellido'),
      isActive: true,
      state: StepState.complete,
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
          ),
        ],
      ),
    ),
    Step(
      isActive: false,
      state: StepState.editing,
      title: const Text('Address'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Home Address'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Postcode'),
          ),
        ],
      ),
    ),
    Step(
      state: StepState.error,
      title: const Text('Avatar'),
      subtitle: const Text("Error!"),
      content: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.red,
          )
        ],
      ),
    ),
  ];

  StepperType stepperType = StepperType.vertical;

  int currentStep = 0;
  bool complete = false;

  next(){
    var nombre = _nombre.text;
    saveOnChanged(nombre);
    currentStep + 1 != steps.length
      ? goTo(currentStep + 1)
      : setState(() => complete = true);
  }

  cancel(){
    if(currentStep > 0){
      goTo(currentStep - 1);
    }
  }

  goTo(int step){
    setState(() => currentStep = step);
  }

  switchStepType(){
    setState(() => stepperType == StepperType.horizontal
      ? stepperType = StepperType.vertical
      : stepperType = StepperType.horizontal
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Editar Cuenta'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            complete ? Expanded(
                    child: Center(
                      child: AlertDialog(
                        title: new Text("Profile Created"),
                        content: new Text(
                          "Tada!",
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              setState(() => complete = false);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Stepper(
                      type: stepperType,
                      steps: steps,
                      currentStep: currentStep,
                      onStepContinue: next,
                      onStepTapped: (step) => goTo(step),
                      onStepCancel: cancel,
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.autorenew),
          onPressed: switchStepType,
        ),
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
  var dateFormat = DateFormat("Hms");


  void calculateDiference(){
    database.once().then((DataSnapshot snapshot) {

      setState(() {
        nombre = snapshot.value['nombre'];
        fecha = DateTime.parse(snapshot.value['fecha']);
        diferencia = new DateTime.now().difference(fecha);
      });
    });
  }

  void initState(){

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => calculateDiference());
    super.initState();
  }
@override
Widget build(BuildContext context) {
  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        padding: EdgeInsets.only(bottom: 16,top: 16),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: Colors.lightGreen),
         
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ), 
            padding: EdgeInsets.all(10),
            child: Center(
              child: Image.asset("assets/images/time.png", width: 70,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
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
          )],
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

  void calculateC(){
      database.once().then((DataSnapshot snapshot){
        fecha = DateTime.parse(snapshot.value['fecha']);
        cantidad = snapshot.value['cantidad'];
        paquete = snapshot.value['paquete'];
      setState(() {
        if (DateTime.now().difference(fecha).inHours >=  diferencia){
          diferencia += 1;
          cigarrillos = paquete * cantidad;
          ahorro += cigarrillos / 24;
        }
      });
      print(ahorro);
      });
  }


  void initState(){
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => calculateC());
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0)),
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
         padding: EdgeInsets.only(bottom: 16,top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: <Widget>[
          Container( 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Image.asset("assets/images/stop-smoking.png", width: 70,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
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
  double ahorro =0;
  Timer timer;
  var fecha;
  var diferencia = 60;
  var sumar;
  String s = "\$" ;

  void calculateSave(){
      database.once().then((DataSnapshot snapshot){
        fecha = DateTime.parse(snapshot.value['fecha']);
        precio = snapshot.value['precio'];
        cantidad = snapshot.value['cantidad'];
      setState(() {
        sumar = (precio * cantidad) / 24;
        if (DateTime.now().difference(fecha).inMinutes >=  diferencia){
          diferencia += 60;
          ahorro += sumar;
        }
      });
      });
  }


  void initState(){
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => calculateSave());
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {

  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0)),
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
         padding: EdgeInsets.only(bottom: 11,top: 11),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: <Widget>[
          Container( 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Image.asset("assets/images/ahorrar.png", width: 70,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.lightGreen
            ),
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
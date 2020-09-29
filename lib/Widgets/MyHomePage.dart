import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lufick/Widgets/ConvertedRates.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lufick/Model/Rates.dart';
import 'package:lufick/Provider/RatesProvider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final numberCon=TextEditingController() ;
  List rec=[];
  var decoded=null;
  var data=null;
  var value=null;
  var base='base';
  DateTime pickedDates=DateTime.now();
  var date;
  Map<String,String> ratesRecieved={};
  bool intialCall=false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(!intialCall){
      setState(() {
        date=DateFormat('dd-MM-yyy').format(pickedDates).toString();
        apiCall(1);
        intialCall=true;
      });

    }

  }
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar:AppBar(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                base,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ]
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh,color:Colors.white),onPressed:(){
            setState(() {
              apiCall(2);
            });
          }),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextField(
                controller:numberCon,
                decoration: InputDecoration(labelText: 'Enter the value to convert',border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(width: 1))),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                onPressed:(){
                  setState(() {
                    print(int.parse(numberCon.text));
                    apiCall(int.parse(numberCon.text));
                  });
                },
                color: Theme.of(context).primaryColor,
                child:Text('Convert',style: TextStyle(color: Colors.white),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                elevation: 10,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ConvertedRates(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> apiCall(int number) async {
    int counter=0;
    final dataCollection = Provider.of<RatesProvider>(context);
    String endpoint="https://api.exchangeratesapi.io/latest";
    return http.get(endpoint).then((response) =>
    {
    decoded = jsonDecode(response.body) as Map,
    data = decoded['rates'] as Map,

    base=json.decode(response.body)['base'],date=json.decode(response.body)['date'],
      for (final name in data.keys) {
        value = data[name],
      // print('$name,$value'),
      dataCollection.addRatesAndCode(counter, name, value * number),
      counter++,
    },
      print(dataCollection.dataCollectionsBackup[5].countryCode),
    }).catchError((onError) {
      snackBar('Something went wrong');
    });
  }
  void snackBar(String txt){
    print(txt);
    globalKey.currentState.hideCurrentSnackBar();
    globalKey.currentState.showSnackBar(
        SnackBar(
          content: Container(height: 20, child: Center(child: Text(txt))),
          duration: Duration(seconds: 3),
        ));
  }
}


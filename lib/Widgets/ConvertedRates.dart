import 'package:flutter/material.dart';
import 'package:lufick/Provider/RatesProvider.dart';
import 'package:provider/provider.dart';

class ConvertedRates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataCollection = Provider.of<RatesProvider>(context);
    return Container(
      height: 600,
      child: ListView.builder(itemBuilder: _listBuilder,itemCount: dataCollection.showAll.length,),
    );
  }
}
Widget _listBuilder(BuildContext context,int index){
  final dataCollection = Provider.of<RatesProvider>(context);
  print('${dataCollection.showAll.values.toList()[index].countryCode}: ${dataCollection.showAll.values.toList()[index].currentRate} ++++');
  return Container(
    height: 50,
    margin: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('${dataCollection.showAll.values.toList()[index].countryCode}',style: TextStyle(fontSize: 13),),
        Text('${dataCollection.showAll.values.toList()[index].currentRate}',style: TextStyle(fontSize: 13),)
      ],
    ),
  );
}

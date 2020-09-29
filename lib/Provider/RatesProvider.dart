
import 'package:flutter/cupertino.dart';
import 'package:lufick/Model/Rates.dart';
import 'package:flutter/material.dart';
class RatesProvider with ChangeNotifier{

  Map<int,Rates> _ratesRepository={};

  Map<int, Rates> get dataCollectionsBackup {
    return {..._ratesRepository};
  }

  void addRatesAndCode(int key,String countryCode,double rate){
    if(_ratesRepository.containsKey(key)){
      _ratesRepository.update(key, (value) => Rates(countryCode: countryCode,currentRate: rate));
      print('${countryCode} : ${rate} => update');
    }else{
      _ratesRepository.putIfAbsent(key, () => Rates(countryCode: countryCode,currentRate: rate));
      print('${countryCode} : ${rate} => changed');
    }
    notifyListeners();
  }

  Map<int, Rates> get showAll {
    return {..._ratesRepository};
  }
}
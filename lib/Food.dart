import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Food{
  String name = '';
  String amount = '';
  DateTime expDate = DateTime.now();
  DateTime dayBought = DateTime.now();
  String location = 'Fridge';
  int daysUntilExp = 0;
  int age = 0;
  bool favorite = false;
  bool isEmpty = true;

  Food();

  Food.fill(this.name,this.amount,this.expDate,this.dayBought,this.location, this.favorite) {
    daysUntilExp = calculateDaysBetween(DateTime.now(), expDate);
    age = calculateDaysBetween(dayBought, DateTime.now());
    isEmpty = false;
  }

  int calculateDaysBetween(DateTime from, DateTime to){
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Food.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = json['amount'],
        expDate = DateTime.parse(json['expDate']),
        dayBought = DateTime.parse(json['dayBought']),
        location = json['location'],
        favorite = json['favorite'],
        daysUntilExp = json['daysUntilExp'],
        age = json['age'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'expDate': expDate.toIso8601String(),
    'dayBought': expDate.toIso8601String(),
    'location': location,
    'favorite': favorite,
    'daysUntilExp': daysUntilExp,
    'age': age,
  };

}
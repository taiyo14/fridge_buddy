import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Food{
  String name = '';
  String amount = '';
  DateTime? expDate = null;
  DateTime? dayBought = null;
  String location = '';
  int daysUntilExp = 0;
  int age = 0;
  bool favorite = false;

  Food(String name,String amount,DateTime expDate,DateTime dayBought,String location, bool favorite) {
    this.name = name;
    this.amount = amount;
    this.expDate = expDate;
    this.dayBought = dayBought;
    this.location = location;
    this.favorite = favorite;
    this.daysUntilExp = calculateDaysBetween(DateTime.now(), expDate);
    this.age = calculateDaysBetween(dayBought, DateTime.now());
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
    'expDate': expDate?.toIso8601String(),
    'dayBought': dayBought?.toIso8601String(),
    'location': location,
    'favorite': favorite,
    'daysUntilExp': daysUntilExp,
    'age': age,
  };



}
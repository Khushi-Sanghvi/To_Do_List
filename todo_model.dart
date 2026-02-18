import 'dart:convert';
import 'package:flutter/material.dart';

class TodoItem {
  String title;
  bool isDone;
  IconData icon;
  DateTime date;

  TodoItem({
    required this.title,
    this.isDone = false,
    this.icon = Icons.task,
    required this.date,
  });

  String toJson() => jsonEncode({
    'title': title,
    'isDone': isDone,
    'icon': icon.codePoint,
    'date': date.toIso8601String(),
  });

  factory TodoItem.fromJson(String json) {
    final data = jsonDecode(json);
    return TodoItem(
      title: data['title'],
      isDone: data['isDone'],
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
      date: DateTime.parse(data['date']),
    );
  }
}

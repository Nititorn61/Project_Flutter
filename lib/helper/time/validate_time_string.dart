import 'package:flutter/material.dart';

bool verifyTime(String timeString) {
  TimeOfDay time = TimeOfDay.now();
  List<String> x = timeString.split(":");
  int hour = int.parse(x.first);
  int minute = int.parse(x.last);
  if (time.hour <= hour) {
    if (hour > time.hour) return true;
    return time.minute <= minute;
  } else {
    return false;
  }
}

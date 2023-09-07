import 'dart:io';

import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/application_user_model.dart';
import 'package:car_okay/models/booking_model.dart';
import 'package:car_okay/models/car_types_model.dart';
import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/models/reservation_model.dart';
import 'package:car_okay/models/services_controller_model.dart';
import 'package:car_okay/models/services_model.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'firebase_car.dart';
part 'firebase_car_types.dart';
part 'firebase_user.dart';
part 'firebase_store.dart';
part 'firebase_service.dart';
part 'firebase_reservations.dart';
part 'firebase_booking.dart';

import 'dart:io' show Platform;

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/car_types_cubit.dart';
import 'package:car_okay/bloc/reservation_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/service_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      name: "car_okay",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CarCubit()),
        BlocProvider(create: (_) => CarTypesCubit()),
        BlocProvider(create: (_) => StoreCubit()),
        BlocProvider(create: (_) => ServiceCubit()),
        BlocProvider(create: (_) => ReservationCubit()),
      ],
      child: MaterialApp(
        title: 'Car Wash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: const SplashPage(),
      ),
    );
  }
}

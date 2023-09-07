import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    intailize();
    super.initState();
  }

  Future<void> intailize() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    await context.read<AuthCubit>().checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(
          child: Image.asset(logoUri),
        ),
      ),
    );
  }
}

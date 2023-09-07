import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/car_types_cubit.dart';
import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/pages/car/car_register_page.dart';
import 'package:car_okay/pages/google_map_page.dart';
import 'package:car_okay/pages/profile_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final int index;
  final int subpageIndex;
  const HomePage({super.key, this.index = 0, this.subpageIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CarTypesCubit _carTypesCubit;
  late CarCubit _carCubit;
  late AuthCubit _authCubit;

  List<Widget> pageOptions = [
    const GoogleMapPage(),
    const ProfilePage(),
  ];

  bool _loading = true;
  int _selectedIndex = 0;
  late Widget currentPage = pageOptions.first;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _carTypesCubit = context.read<CarTypesCubit>();
    _carCubit = context.read<CarCubit>();
    pageOptions = <Widget>[
      const GoogleMapPage(),
      ProfilePage(
        subpageIndex: widget.subpageIndex,
      ),
    ];
    _selectedIndex = widget.index;
    currentPage = pageOptions[widget.index];
    getInitProp();
    super.initState();
  }

  Future<void> getInitProp() async {
    final response = await Future.wait([
      _carCubit.getCarsByUserId(context, userId: _authCubit.getUserId()),
      _carTypesCubit.getCarTypesFromFirebase()
    ]);

    bool isUserHaveCars = response.first as bool;
    if (!isUserHaveCars && mounted) {
      CONavigator.pushReplacement(context, const CarRegistrPage());
    } else {
      _loading = false;
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    if (widget.index != 0 || widget.subpageIndex != 0) {
      pageOptions = [
        const GoogleMapPage(),
        const ProfilePage(),
      ];
    }
    currentPage = pageOptions.elementAt(index);
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          CODialog.confirm(context, title: "ยืนยันการออกจากแอพ", onConfirm: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          });
        } else {
          pageOptions = [
            const GoogleMapPage(),
            const ProfilePage(),
          ];
          currentPage = pageOptions.elementAt(0);
          _selectedIndex = 0;
          setState(() {});
        }
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/image/map.png',
                width: 25,
                height: 25,
              ),
              activeIcon: Image.asset(
                'assets/image/map_selected.png',
                width: 25,
                height: 25,
              ),
              label: 'ค้นหาร้านที่ให้บริการ',
              backgroundColor: Colors.red,
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
                size: 30,
              ),
              label: 'อื่นๆ',
              backgroundColor: Colors.red,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: buttonPrimaryBackground,
          onTap: _onItemTapped,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : currentPage,
      ),
    );
  }
}

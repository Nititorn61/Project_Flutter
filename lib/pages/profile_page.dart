import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/pages/reservation/menu_reservation_page.dart';
import 'package:car_okay/pages/store/menu_store_page.dart';
import 'package:car_okay/pages/user/add_car_page.dart';
import 'package:car_okay/pages/user/edit_car_page.dart';
import 'package:car_okay/pages/user/edit_profile_page.dart';
import 'package:car_okay/pages/user/manage_car_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_navigate_button.dart';
import 'package:car_okay/widgets/image/car_okay_image_user.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  final int subpageIndex;
  const ProfilePage({super.key, this.subpageIndex = 0});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthCubit _authCubit;
  late Widget current;
  late PreferredSizeWidget appBar;

  final List<String> _menu = const [
    "แก้ไขข้อมูลส่วนตัว",
    "จัดการข้อมูลรถ",
    "รายการที่เข้ารับบริการ",
    "เปิดโหมดร้านค้า",
    "ออกจากระบบ"
  ];

  void onPressedBack() {
    current = _builder();
    appBar = _appBarBuilder();
    setState(() {});
  }

  void _onBackToManageCarPage() {
    current = ManageCarPage(
      onPressedBack: onPressedBack,
      onPressedAddCar: _onPressedAddCar,
      onPressedEditCar: _onPressedEditCar,
    );
    appBar = AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: onPressedBack,
        color: Colors.white,
      ),
      title: const COAppBarText("จัดการข้อมูลรถ"),
      backgroundColor: appBarBackgroundColor,
      elevation: 1,
    );
    setState(() {});
  }

  void _onPressedAddCar() {
    current = AddCarPage(onPressedBack: _onBackToManageCarPage);
    appBar = AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: _onBackToManageCarPage,
        color: Colors.white,
      ),
      title: const COAppBarText("ลงทะเบียนรถ"),
      backgroundColor: appBarBackgroundColor,
      elevation: 1,
    );

    setState(() {});
  }

  void _onPressedEditCar(CarModel car) {
    current = EditCarPage(
      onPressedBack: _onBackToManageCarPage,
      car: car,
    );
    appBar = AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: _onBackToManageCarPage,
        color: Colors.white,
      ),
      title: const COAppBarText("แก้ไขข้อมูลรถ"),
      backgroundColor: appBarBackgroundColor,
      elevation: 1,
    );

    setState(() {});
  }

  Widget _builder() {
    final user = _authCubit.state!;
    return Column(
      children: [
        const COPadding(height: 1),
        COImageUser(user.photoURL),
        COText(
          "${user.firstName} ${user.lastName}",
          fontSize: 18,
          bold: true,
        ),
        COText("เบอร์โทรศัพท์ : ${user.phoneNumber}"),
        COText("Email : ${user.email}"),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: _menu.asMap().entries.map<Widget>((entry) {
              int idx = entry.key;
              String val = entry.value;
              return CONavigateButton(
                onPressed: () => _onPressed(idx),
                title: val,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBarBuilder() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const COAppBarText("อื่นๆ"),
      backgroundColor: appBarBackgroundColor,
      elevation: 1,
    );
  }

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    if (widget.subpageIndex != 2) {
      current = _builder();
      appBar = _appBarBuilder();
    } else {
      current = MenuReservationPage(
        onPressedBack: onPressedBack,
      );
      appBar = AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: onPressedBack,
          color: Colors.white,
        ),
        title: const COAppBarText("รายการที่เข้ารับบริการ"),
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
      );
    }
    setState(() {});
    super.initState();
  }

  void _onPressed(int index) {
    switch (index) {
      case 0:
        current = const EditProfilePage();
        appBar = AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: onPressedBack,
            color: Colors.white,
          ),
          title: const COAppBarText("แก้ไขข้อมูลส่วนตัว"),
          backgroundColor: appBarBackgroundColor,
          elevation: 1,
        );
        setState(() {});
        return;
      case 1:
        current = ManageCarPage(
          onPressedBack: onPressedBack,
          onPressedAddCar: _onPressedAddCar,
          onPressedEditCar: (car) {
            _onPressedEditCar(car);
          },
        );
        appBar = AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: onPressedBack,
            color: Colors.white,
          ),
          title: const COAppBarText("จัดการข้อมูลรถ"),
          backgroundColor: appBarBackgroundColor,
          elevation: 1,
        );
        setState(() {});
        return;
      case 2:
        current = MenuReservationPage(
          onPressedBack: onPressedBack,
        );
        appBar = AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: onPressedBack,
            color: Colors.white,
          ),
          title: const COAppBarText("รายการที่เข้ารับบริการ"),
          backgroundColor: appBarBackgroundColor,
          elevation: 1,
        );
        setState(() {});
        return;
      case 3:
        CONavigator.push(context, const MenuStorePage());
        return;
      case 4:
        _authCubit.logout(context);
        return;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: Colors.white70,
        height: double.maxFinite,
        width: double.maxFinite,
        child: current,
      ),
    );
  }
}

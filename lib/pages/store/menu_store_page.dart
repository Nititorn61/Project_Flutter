import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/pages/booking/update_booking_page.dart';
import 'package:car_okay/pages/booking/verify_booking_page.dart';
import 'package:car_okay/pages/service/menu_service_page.dart';
import 'package:car_okay/pages/stats_page.dart';
import 'package:car_okay/pages/store/add_store_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_navigate_button.dart';
import 'package:car_okay/widgets/image/car_okay_image_user.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuStorePage extends StatefulWidget {
  const MenuStorePage({super.key});

  @override
  State<MenuStorePage> createState() => _MenuStorePageState();
}

class _MenuStorePageState extends State<MenuStorePage> {
  late AuthCubit _authCubit;
  late StoreCubit _storeCubit;

  final List<String> _menu = const [
    "เพิ่ม/แก้ไขข้อมูลร้านค้า",
    "จัดการข้อมูลบริการ",
    "รายการรอยืนยันการจองคิว",
    "รายการที่เข้ารับบริการ",
    "สถิติการใช้งาน",
    "เปิดโหมดผู้ใช้บริการ",
    "ออกจากระบบ",
  ];

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _storeCubit = context.read<StoreCubit>();
    _storeCubit.getMyStore(context, userId: _authCubit.getUserId());
    super.initState();
  }

  void _onPressed(BuildContext context, int index) {
    switch (index) {
      case 0:
        CONavigator.push(
          context,
          const AddStorePage(),
        );
        return;
      case 1:
        CONavigator.push(
          context,
          const MenuServicePage(),
        );
        return;
      case 2:
        CONavigator.push(
          context,
          const VerifyBookingPage(),
        );
        return;
      case 3:
        CONavigator.push(
          context,
          const UpdateBookingPage(),
        );
        return;
      case 4:
        CONavigator.push(
          context,
          const StatsPage(),
        );
        return;
      case 5:
        Navigator.of(context).pop();
        return;
      case 6:
        _authCubit.logout(context);
        return;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const COAppBarText("โหมดร้านค้า"),
          backgroundColor: appBarBackgroundColor,
          elevation: 1,
        ),
        body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              // runSpacing: defaultPadding * 1.5,
              children: [
                const COPadding(height: 1),
                BlocBuilder<StoreCubit, StoreModel>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        COImageUser(state.displayPhoto),
                        COText(
                          state.name,
                          bold: true,
                          fontSize: 22,
                        ),
                      ],
                    );
                  },
                ),
                const COPadding(height: 1),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: _menu.asMap().entries.map<Widget>((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return CONavigateButton(
                        onPressed: () => _onPressed(context, idx),
                        title: val,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

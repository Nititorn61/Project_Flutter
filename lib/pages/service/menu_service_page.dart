import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/service_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/models/services_model.dart';
import 'package:car_okay/pages/service/add_service_page.dart';
import 'package:car_okay/pages/service/edit_service_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/padding/car_okay_floating_button_padding.dart';
import 'package:car_okay/widgets/text/car_okay_menu_text.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuServicePage extends StatefulWidget {
  const MenuServicePage({super.key});

  @override
  State<MenuServicePage> createState() => _MenuServicePageState();
}

class _MenuServicePageState extends State<MenuServicePage> {
  late AuthCubit _authCubit;
  late StoreCubit _storeCubit;
  late ServiceCubit _serviceCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _storeCubit = context.read<StoreCubit>();
    _serviceCubit = context.read<ServiceCubit>();
    init();
    super.initState();
  }

  Future<void> init() async {
    await _storeCubit.getMyStore(context, userId: _authCubit.getUserId());
    if (mounted) {
      await _serviceCubit.getMyStoreService(
        context,
        storeUid: _storeCubit.state.id,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const COAppBarText("จัดการข้อมูลบริการ"),
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: BlocBuilder<ServiceCubit, List<ServicesModel>>(
              builder: (context, state) {
                return Column(children: [
                  ...state.map((model) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(defaultCardRadius),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: padding,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                COMenuText(
                                  heading: "บริการ",
                                  content: model.name,
                                ),
                                COMenuText(
                                  heading: "ระยะเวลาให้บริการ",
                                  content: "${model.duration} นาที",
                                ),
                                const COText("ประเภทรถที่ให้บริการ",
                                    bold: true),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: model.prices.map((price) {
                                    return COText(
                                      "\u2022 ${price.carType}\t\t${price.price} บาท",
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      CONavigator.push(
                                        context,
                                        EditServicePage(model: model),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      CODialog.confirm(
                                        context,
                                        title:
                                            "ยืนยันการลบบริการ ${model.name}",
                                        onConfirm: () async {
                                          await _serviceCubit.removeService(
                                            context,
                                            docId: model.id,
                                            storeUid: _storeCubit.state.id,
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const COFloatingButtonPadding(),
                ]);
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: padding,
        width: double.maxFinite,
        child: COElevatedButton(
          onPressed: () => CONavigator.push(context, const AddServicePage()),
          child: const COText(
            "เพิ่มบริการ",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

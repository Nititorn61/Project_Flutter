import 'package:car_okay/bloc/service_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/services_controller_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/dropdown/car_okay_dropdown.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  late ServiceCubit _serviceCubit;
  late StoreCubit _storeCubit;

  TextEditingController name = TextEditingController();
  String? _dropdownSelected;
  late List<ServiceControllerModel> prices = [];

  void onDropdownChange(String? selected) {
    if (selected != null) {
      _dropdownSelected = selected;
      setState(() {});
    }
  }

  void onCheckboxChange(bool checked, String label) {
    var updateIndex = prices.indexWhere((element) => element.label == label);
    prices[updateIndex] = prices[updateIndex].copyWith(checked: checked);
    setState(() {});
  }

  void _handleOnPressedSubmit() {
    if (_dropdownSelected == null) {
      COSnackBar.show(context, title: "กรุณาเลือกเวลา");
      return;
    }

    _serviceCubit.addService(
      context,
      storeUid: _storeCubit.state.id,
      name: name.text,
      duration: _dropdownSelected!,
      prices: prices,
    );
  }

  @override
  void initState() {
    _serviceCubit = context.read<ServiceCubit>();
    _storeCubit = context.read<StoreCubit>();
    for (var carType in carTypesList) {
      prices.add(
        ServiceControllerModel(
          controller: TextEditingController(),
          checked: false,
          label: carType,
        ),
      );
    }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    for (var price in prices) {
      price.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const COAppBarText("เพิ่มบริการ"),
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                COTextField(
                  label: "ชื่อบริการ",
                  hintText: "ชื่อบริการ",
                  controller: name,
                ),
                const COPadding(height: 1),
                CODropdownButton(
                  label: "ระยะเวลาที่ให้บริการ",
                  hint: "ระยะเวลาที่ให้บริการ",
                  value: _dropdownSelected,
                  list:
                      serviceDurationList.map((String s) => "$s นาที").toList(),
                  onChanged: onDropdownChange,
                ),
                const COPadding(height: 1),
                const COText("ประเภทรถที่ให้บริการ", bold: true),
                const COPadding(height: 1),
                Wrap(
                  runSpacing: defaultPadding,
                  children: prices.map((ServiceControllerModel price) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: price.checked,
                          onChanged: (bool? checked) {
                            if (checked != null) {
                              onCheckboxChange(checked, price.label);
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(price.label),
                        ),
                        Expanded(
                          flex: 2,
                          child: COTextField(
                            controller: price.controller,
                            hintText: "ค่าบริการ",
                            label: null,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const COPadding(width: 1),
                        const Text("บาท"),
                      ],
                    );
                  }).toList(),
                ),
                const COPadding(height: 1),
                SizedBox(
                  width: double.maxFinite,
                  child: COElevatedButton(
                    backgroundColor: prices.isEmpty ||
                            name.text.isEmpty ||
                            _dropdownSelected == null
                        ? inActiveTextColor
                        : buttonPrimaryBackground,
                    onPressed: prices.isEmpty ||
                            name.text.isEmpty ||
                            _dropdownSelected == null
                        ? null
                        : _handleOnPressedSubmit,
                    child: const COText(
                      "บันทึก",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

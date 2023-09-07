import 'package:car_okay/bloc/service_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/layout/car_okay_full_screen_layout.dart';
import 'package:car_okay/models/prices_model.dart';
import 'package:car_okay/models/services_controller_model.dart';
import 'package:car_okay/models/services_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/dropdown/car_okay_dropdown.dart';
import 'package:car_okay/widgets/heading/car_okay_heading.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditServicePage extends StatefulWidget {
  final ServicesModel model;
  const EditServicePage({super.key, required this.model});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
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

    _serviceCubit.editService(
      context,
      docId: widget.model.id,
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
      name.text = widget.model.name;
      _dropdownSelected = "${widget.model.duration} นาที";
      List<PricesModel> list = widget.model.prices
          .where((element) => element.carType == carType)
          .toList();
      if (list.isNotEmpty) {
        prices.add(
          ServiceControllerModel(
            controller:
                TextEditingController(text: list.first.price.toString()),
            checked: true,
            label: carType,
          ),
        );
      } else {
        prices.add(
          ServiceControllerModel(
            controller: TextEditingController(),
            checked: false,
            label: carType,
          ),
        );
      }
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
    return COFullScreenLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              COHeading(
                onPressedBack: () => Navigator.of(context).pop(),
                title: "แก้ไขบริการ",
              ),
              COTextField(
                label: "ชื่อบริการ",
                hintText: "ชื่อบริการ",
                controller: name,
              ),
              CODropdownButton(
                label: "ระยะเวลาที่ให้บริการ",
                hint: "ระยะเวลาที่ให้บริการ",
                value: _dropdownSelected,
                list: serviceDurationList.map((String s) => "$s นาที").toList(),
                onChanged: onDropdownChange,
              ),
              const COText("ประเภทรถที่ให้บริการ", bold: true),
              const COPadding(height: 1),
              ...prices.map((ServiceControllerModel price) {
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
                      ),
                    ),
                    const COPadding(width: 1),
                    const Text("บาท"),
                  ],
                );
              }),
              Padding(
                padding: padding,
                child: SizedBox(
                  width: double.maxFinite,
                  child: COElevatedButton(
                    onPressed: _handleOnPressedSubmit,
                    child: const COText(
                      "บันทึก",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/car_types_cubit.dart';
import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/models/car_types_model.dart';
import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/image/car_okay_image_car.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageCarPage extends StatefulWidget {
  final void Function() onPressedBack;
  final void Function() onPressedAddCar;
  final void Function(CarModel car) onPressedEditCar;
  const ManageCarPage({
    super.key,
    required this.onPressedBack,
    required this.onPressedAddCar,
    required this.onPressedEditCar,
  });

  @override
  State<ManageCarPage> createState() => _ManageCarPageState();
}

class _ManageCarPageState extends State<ManageCarPage> {
  late AuthCubit _authCubit;
  late CarCubit _carCubit;
  late CarTypesCubit _carTypesCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _carTypesCubit = context.read<CarTypesCubit>();
    _carCubit = context.read<CarCubit>();
    super.initState();
  }

  void _onPressedDelete(CarModel car, CarTypes type) {
    CODialog.confirm(
      context,
      title: "ยืนยันการลบ",
      content: "${type.brand} ${type.model} ทะเบียน ${car.plate}",
      onConfirm: () async {
        await _carCubit.removeCar(
          context,
          userUid: _authCubit.getUserId(),
          car: car,
        );
      },
    );
  }

  void _onPressedEdit(CarModel car) {
    widget.onPressedEditCar(car);
  }

  Widget _cardRender(CarModel car) {
    final carType = _carTypesCubit.findCarTypesById(car.carTypesId);

    return SizedBox(
      height: 120,
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultCardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              COImageCar(
                car.photoURL,
                size: 30,
              ),
              const COPadding(width: 2),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          COText("${carType.brand} (${carType.model})"),
                          COText("ประเภทรถ : ${carType.type}"),
                          COText("ทะเบียนรถ : ${car.plate}"),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              _onPressedEdit(car);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          Visibility(
                            visible: _carCubit.state.length > 1,
                            child: IconButton(
                              onPressed: () {
                                _onPressedDelete(car, carType);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CarCubit, List<CarModel>>(
        builder: (context, state) {
          return SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: defaultPadding * 2,
                  children: [
                    ...state.map((car) => _cardRender(car)).toList(),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: padding,
        width: double.maxFinite,
        child: COElevatedButton(
          onPressed: widget.onPressedAddCar,
          child: const COText(
            "ลงทะเบียนรถเพิ่มเติม",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

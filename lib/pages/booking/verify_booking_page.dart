import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/reservation_cubit.dart';
import 'package:car_okay/bloc/service_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/helper/time/filter_status_and_date_time.dart';
import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/models/reservation_model.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:car_okay/widgets/image/car_okay_image_car.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_menu_text.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class VerifyBookingPage extends StatefulWidget {
  const VerifyBookingPage({super.key});

  @override
  State<VerifyBookingPage> createState() => _VerifyBookingPageState();
}

class _VerifyBookingPageState extends State<VerifyBookingPage> {
  late AuthCubit _authCubit;
  late CarCubit _carCubit;
  late StoreCubit _storeCubit;
  late ServiceCubit _serviceCubit;
  late ReservationCubit _reservationCubit;

  TextEditingController date = TextEditingController(
      text: DateTime.now().toIso8601String().split("T").first);

  Map<String, String> storename = {};
  Map<String, String> userDisplayName = {};

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _carCubit = context.read<CarCubit>();
    _serviceCubit = context.read<ServiceCubit>();
    _storeCubit = context.read<StoreCubit>();
    _reservationCubit = context.read<ReservationCubit>();
    _init();
    super.initState();
  }

  Future<ReservationModel> getDetails(ReservationModel model) async {
    String displayName;
    CarModel? car;

    //Create index table for user
    if (userDisplayName[model.userId] == null) {
      displayName = await _authCubit.getNameByUuid(model.userId);
      userDisplayName[model.userId] = displayName;
    } else {
      displayName = userDisplayName[model.userId]!;
    }
    car = await _carCubit.getCarsById(carId: model.carId);
    var future = await Future.wait(model.servicesList
        .map((String id) => _serviceCubit.getServiceById(id)));
    return model.copyWith(
        servicesDetailsList: future, displayName: displayName, car: car);
  }

  Future<void> getStoreDetails(String storeId) async {
    StoreModel store = await _storeCubit.getStoreByUid(storeId);
    storename = {...storename, storeId: store.name};
    return;
  }

  Future<void> _init() async {
    var raw = await _reservationCubit.getListReservationInStore(
      context,
      storeId: _storeCubit.state.id,
    );

    await Future.wait(
      raw.map((e) => e.storeId).toSet().toList().map(
            (storeId) => getStoreDetails(storeId),
          ),
    );
    List<ReservationModel> t = await Future.wait(
      raw.map((e) => getDetails(e)),
    );

    List<ReservationModel> sorted = [];

    final List<String> sortBy = [
      "รอการยืนยัน",
      "จองคิวสำเร็จ",
      "กำลังดำเนินการ",
      "เสร็จสิ้น",
      "ยกเลิก",
    ];

    for (var status in sortBy) {
      for (var model in t) {
        if (model.status == status) {
          sorted.add(model);
        }
      }
    }

    _reservationCubit.updateReservationDetails(sorted);
    setState(() {});
  }

  Future<void> _onPreesedVerify(ReservationModel model) async {
    await _reservationCubit.updateStatusReservation(context,
        reservationModel: model, status: reservationStatusList.elementAt(1));
    _init();
  }

  Future<void> _onPressedCancle(ReservationModel model) async {
    await _reservationCubit.updateStatusReservation(context,
        reservationModel: model, status: reservationStatusList.last);
    _init();
  }

  @override
  void dispose() {
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const COAppBarText("รายการรอยืนยันการจองคิว"),
        elevation: 1,
        backgroundColor: Colors.black87,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: COTextField(
                        label: "เดือน",
                        controller: date,
                        onPressed: () async {
                          DateTime? select = await showMonthPicker(
                            context: context,
                            initialDate: date.text.isEmpty
                                ? DateTime.now()
                                : DateTime.parse(date.text),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (select != null) {
                            date.text =
                                select.toIso8601String().split("T").first;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const COPadding(height: 1),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: BlocBuilder<ReservationCubit, List<ReservationModel>>(
                  builder: (context, state) {
                    final filter2 = filterStatusAndDateTime(
                      status: reservationStatusList.first,
                      dateTime: date.text,
                      list: state,
                    );

                    if (filter2.isEmpty) {
                      return const Center(
                        child: COText(
                          listEmptyMessage,
                          bold: true,
                        ),
                      );
                    }

                    return Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: defaultPadding * 2,
                      children: filter2.map((resv) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultCardRadius),
                          ),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    COImageCar(
                                      resv.car?.photoURL,
                                      size: 40,
                                    ),
                                    const COPadding(width: 1),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        COMenuText(
                                          heading: "ทะเบียนรถ",
                                          content: resv.car?.plate ?? "",
                                        ),
                                        COMenuText(
                                          heading: "ผู้ใช้บริการ",
                                          content: resv.displayName ?? "",
                                        ),
                                        COMenuText(
                                          heading: "วันที่จอง",
                                          content: resv.date,
                                        ),
                                        COMenuText(
                                          heading: "ช่องบริการที่จอง",
                                          content: resv.storeSlot.toString(),
                                        ),
                                        COMenuText(
                                          heading: "เวลาที่จอง",
                                          content:
                                              "${timeStringList[resv.timeSlot]} - ${timeStringList[resv.timeSlot + resv.duration - 1]}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsets.all(
                                            defaultPadding / 2),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          CODialog.verifyBooking(
                                            context,
                                            model: resv,
                                            onPressed: () {
                                              _onPreesedVerify(resv);
                                            },
                                            onCancle: () {
                                              _onPressedCancle(resv);
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.search),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

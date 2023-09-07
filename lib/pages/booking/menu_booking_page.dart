import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/car_types_cubit.dart';
import 'package:car_okay/bloc/reservation_cubit.dart';
import 'package:car_okay/bloc/service_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/bottomSheet/car_okay_bottom_sheet.dart';
import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/helper/time/validate_time_string.dart';
import 'package:car_okay/models/booking_model.dart';
import 'package:car_okay/models/booking_table_model.dart';
import 'package:car_okay/models/cars_with_type_model.dart';
import 'package:car_okay/models/services_model.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/image_compress.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:car_okay/widgets/box/car_okay_box.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_picker.dart';
import 'package:car_okay/widgets/dropdown/car_okay_dropdown.dart';
import 'package:car_okay/widgets/padding/car_okay_floating_button_padding.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_center_text.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MenuBookingPage extends StatefulWidget {
  final void Function() onPressedBack;
  final StoreModel store;

  const MenuBookingPage({
    super.key,
    required this.store,
    required this.onPressedBack,
  });

  @override
  State<MenuBookingPage> createState() => _MenuBookingPageState();
}

class _MenuBookingPageState extends State<MenuBookingPage> {
  late AuthCubit _authCubit;
  late StoreCubit _storeCubit;
  late CarCubit _carCubit;
  late ServiceCubit _serviceCubit;
  late CarTypesCubit _carTypesCubit;
  late ReservationCubit _reservationCubit;
  String? selectedCar;
  CarWithTypeModel? car;
  List<CarWithTypeModel> mycar = [];
  List<ServicesModel> servicesList = [];
  TextEditingController date = TextEditingController();
  List<String> slot = [];
  String? selectedSlot;
  int currentPage = 1;
  List<BookingTableModel> bookingList = [];
  BookingModel? bookingModel;
  int? selectedTime;
  int timeInUnit = 0;
  int fee = 0;
  Widget? actionButton;
  late List<String> follows;

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _carCubit = context.read<CarCubit>();
    _serviceCubit = context.read<ServiceCubit>();
    _carTypesCubit = context.read<CarTypesCubit>();
    _reservationCubit = context.read<ReservationCubit>();
    _storeCubit = context.read<StoreCubit>();
    follows = widget.store.follows;
    _init();

    super.initState();
  }

  void _init() async {
    List<dynamic> success = await Future.wait([
      _carCubit.getCarsByUserId(
        context,
        userId: _authCubit.getUserId(),
      ),
      _serviceCubit.getMyStoreService(context, storeUid: widget.store.id),
    ]);

    if (success[0]) {
      for (var i = 0; i < widget.store.slot; i++) {
        slot.add("${i + 1}");
      }
      mycar = _carCubit.state.map<CarWithTypeModel>((car) {
        return CarWithTypeModel(
          id: car.id,
          userUid: car.userId,
          carTypesUid: car.carTypesId,
          plate: car.plate,
          photoURL: car.photoURL,
          carTypes: _carTypesCubit.findCarTypesById(car.carTypesId),
        );
      }).toList();

      setState(() {});
      if (mounted) {
        if (widget.store.promotion.isNotEmpty) {
          CODialog.promotion(context, promotion: widget.store.promotion);
        }
      }
    }
  }

  Future<void> getBookingModel() async {
    DateTime currentDate =
        DateTime.parse(DateTime.now().toIso8601String().split("T").first);
    bookingModel = await _reservationCubit.getBooking(
      context,
      storeId: widget.store.id,
      date: date.text,
      slot: int.parse(selectedSlot!),
    );
    int openUnit = timeStringList.indexOf(widget.store.open);
    int closeUnit = timeStringList.indexOf(widget.store.close);
    bookingList = [];
    for (int index = 0; index < timeStringList.length - 1; index++) {
      bool isShow = index >= openUnit && index <= closeUnit;
      bool isSelectAble = true;

      if (DateTime.parse(date.text).difference(currentDate).inSeconds <= 0) {
        isSelectAble = verifyTime(timeStringList[index]);
        if (isSelectAble) {
          isSelectAble = !bookingModel!.reserved.contains(index);
        }
      }
      bookingList.add(BookingTableModel(
          index: index,
          time: timeStringList[index],
          isSelectAble: isSelectAble,
          isShow: isShow));
    }
    setState(() {});
  }

  void _onNextPage() {
    currentPage += 1;
    setState(() {});
  }

  void _onPrevPage() {
    currentPage -= 1;
    setState(() {});
  }

  Future<void> _onFollows() async {
    final String id = _authCubit.getUserId();
    final bool isFollowed = follows.contains(_authCubit.getUserId());
    if (isFollowed) {
      follows.remove(id);
    } else {
      follows.add(id);
    }
    await _storeCubit.updateFollow(context,
        isAdded: isFollowed, userId: id, store: widget.store);
    setState(() {});
  }

  Widget _pageBuilder() {
    switch (currentPage) {
      case 1:
        actionButton = COElevatedButton(
          backgroundColor: selectedCar == null || servicesList.isEmpty
              ? inActiveTextColor
              : buttonPrimaryBackground,
          onPressed:
              selectedCar == null || servicesList.isEmpty ? null : _onNextPage,
          child: const COText(
            "ถัดไป",
            color: Colors.white,
          ),
        );
        return _page1();
      case 2:
        actionButton = buttonBuilder(
          isDisable: date.text.isEmpty ||
              selectedSlot == null ||
              bookingList.where((e) => e.isSelected).isEmpty,
        );
        return _page2();
      case 3:
        actionButton = buttonBuilder(isDisable: false);
        return _page3();
      case 4:
        actionButton = Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: COElevatedButton(
                  onPressed: _onPrevPage,
                  child: const COText(
                    "ก่อนหน้า",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const COPadding(width: 2),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: COElevatedButton(
                  backgroundColor: imageFile == null
                      ? inActiveTextColor
                      : buttonPrimaryBackground,
                  onPressed: imageFile == null ? null : _submit,
                  child: const COText(
                    "ยืนยันการชำระเงิน",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
        return _page4();
      default:
        currentPage = 1;
        return _page1();
    }
  }

  void _onPicker(int index) async {
    XFile? image;
    if (index == 0) {
      final status = await Permission.camera.request();
      if (status.isDenied && mounted) {
        COSnackBar.show(context, title: "Camera permission denied");
      } else {
        image = await _picker.pickImage(source: ImageSource.camera);
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied && mounted) {
        COSnackBar.show(context, title: "Gallery permission denied");
      } else {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
    }
    if (image != null) {
      File compress = await COImageCompress(image.path).getCompressFile();
      imageFile = compress;
      setState(() {});
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _submit() async {
    await _reservationCubit.addReservation(context, widget.onPressedBack,
        storeId: widget.store.id,
        userId: _authCubit.getUserId(),
        status: reservationStatusList.first,
        storeSlot: int.parse(selectedSlot!),
        date: date.text,
        timeSlot: selectedTime!,
        duration: timeInUnit,
        servicesList: servicesList.map((service) => service.id).toList(),
        fee: fee,
        carId: car!.id,
        carType: car!.carTypes.type,
        imageFile: imageFile!,
        bookingId: bookingModel!.id,
        reserved: bookingModel!.reserved
        // reserved: bookingList
        //     .where((element) => element.isSelected || !element.isSelectAble)
        //     .where((element) => element.isSelected || !element.isSelectAble)
        //     .map((e) => e.index)
        //     .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;
    final isFollowed = follows.contains(_authCubit.getUserId());

    return WillPopScope(
      onWillPop: () async {
        widget.onPressedBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: widget.onPressedBack,
            color: Colors.white,
          ),
          centerTitle: true,
          title: COAppBarText(widget.store.name),
          actions: [
            IconButton(
              onPressed: () {
                if (widget.store.promotion.isEmpty) {
                  COSnackBar.show(context, title: "ร้านค้ายังไม่มีโปรโมชั่น");
                } else {
                  CODialog.promotion(context,
                      promotion: widget.store.promotion);
                }
              },
              iconSize: 20,
              icon: Image.asset(promotionUri),
            ),
            IconButton(
              onPressed: () {
                CODialog.rating(context, rate: widget.store.rate);
              },
              iconSize: 20,
              icon: Image.asset(reviewUri),
            ),
          ],
          backgroundColor: appBarBackgroundColor,
          elevation: 1,
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.store.displayPhoto,
                  width: double.maxFinite,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: defaultPadding,
                  bottom: 0,
                  child: COElevatedButton(
                    onPressed: _onFollows,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        COText(
                          follows.length.toString(),
                          color: Colors.white,
                        ),
                        const COPadding(width: 1),
                        COText(
                          isFollowed ? "เลิกติดตาม" : "ติดตาม",
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height - paddingTop - (153 + 200),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: padding,
                      child: _pageBuilder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: padding,
          width: double.maxFinite,
          child: actionButton,
        ),
      ),
    );
  }

  Widget _page4() {
    return Column(
      children: [
        COBox(
          label: "กรุณาแนบหลักฐานการชำระเงิน",
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: COImagePicker(
              onTap: () => COBottomSheet.plain(
                context,
                (index) => _onPicker(index),
              ),
              imageFile: imageFile,
            ),
          ),
        ),
      ],
    );
  }

  Widget _page2() {
    List<BookingTableModel> table = [];
    for (var c in bookingList) {
      if (c.isShow) table.add(c);
    }

    void onTap(int index) {
      //Cut loop when index overflow
      for (int i = 0; i < timeInUnit; i++) {
        if (!bookingList[index + i].isShow) {
          COSnackBar.show(context, title: "ไม่สามารถจองได้ เลยเวลาทำการ");
          return;
        }
        if (!bookingList[index + i].isSelectAble) {
          COSnackBar.show(context,
              title: "ไม่สามารถจองได้ เวลาในการบริการไม่พอ");
          return;
        }
      }

      bookingList =
          bookingList.map((e) => e.copyWith(isSelected: false)).toList();
      for (int i = 0; i < timeInUnit; i++) {
        bookingList[index + i] =
            bookingList[index + i].copyWith(isSelected: true);
      }
      selectedTime = index;
      setState(() {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        COTextField(
          label: "เลือกวันที่ต้องเข้ารับบริการ",
          hintText: "เลือกวันที่ต้องเข้ารับบริการ",
          controller: date,
          onPressed: () async {
            DateTime now = DateTime.now();
            DateTime? d = await showDatePicker(
              context: context,
              initialDate: date.text.isEmpty ? now : DateTime.parse(date.text),
              firstDate: DateTime(
                now.year,
                now.month,
                now.day,
              ),
              lastDate: DateTime(2030),
            );
            if (d != null) {
              date.text = d.toString().split(" ").first;
              setState(() {});

              if (selectedSlot != null) getBookingModel();
            }
          },
        ),
        const COPadding(height: 1),
        CODropdownButton(
          label: "เลือกช่องใช้บริการ",
          hint: "เลือกช่องใช้บริการ",
          value: selectedSlot,
          list: slot,
          onChanged: (String? select) {
            if (select != null) {
              selectedSlot = select;
              setState(() {});

              if (date.text.isNotEmpty) getBookingModel();
            }
          },
        ),
        const COPadding(height: 1),
        Visibility(
          visible: date.text.isNotEmpty && selectedSlot != null,
          child: COBox(
            label: "เลือกเวลาที่ต้องเข้ารับบริการ",
            child: SizedBox(
              width: double.maxFinite,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Wrap(
                    runSpacing: defaultPadding,
                    spacing: defaultPadding,
                    children: table.map((booking) {
                      return InkWell(
                        onTap: () {
                          onTap(booking.index);
                        },
                        child: Container(
                          width: 70,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            color: booking.isSelected
                                ? buttonPrimaryBackground
                                : booking.isSelectAble
                                    ? Colors.black12
                                    : Colors.red,
                          ),
                          child: Column(
                            children: [
                              COText(booking.time),
                              booking.isSelectAble
                                  ? const COText("ว่าง")
                                  : const COText("ไม่ว่าง"),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _page1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CODropdownButton(
              label: "เลือกรถที่ต้องการจองคิว",
              hint: "กรุณาเลือกรถที่ต้องการจองคิว",
              value: selectedCar,
              list: mycar.map((car) => car.plate).toList(),
              onChanged: (String? selected) {
                selectedCar = selected;
                car = mycar.where((c) => c.plate == selected).first;
                setState(() {});
              },
            ),
          ],
        ),
        const COPadding(height: 1),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const COText(
              "เลือกรายการที่ต้องการรับบริการ",
              bold: true,
              textAlign: TextAlign.left,
            ),
            const COPadding(height: 1),
            BlocBuilder<ServiceCubit, List<ServicesModel>>(
              builder: (context, state) {
                if (car == null) {
                  return const COText("ท่านยังไม่ได้เลือกรถ");
                }

                List<ServicesModel> filterServiceList = [];

                for (var service in state) {
                  bool isAddToServiceList = service.prices
                      .where((element) => element.carType == car!.carTypes.type)
                      .isNotEmpty;
                  if (isAddToServiceList) {
                    filterServiceList.add(service);
                  }
                }

                if (filterServiceList.isEmpty) {
                  return const COText(
                    "ไม่มีรายการให้บริการในประเภทรถคันนี้",
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: inputPrimaryBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        defaultRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: defaultPadding,
                        right: defaultPadding,
                        bottom: defaultPadding,
                      ),
                      child: Column(
                        children: filterServiceList.map<Row>(
                          (service) {
                            int price = service.prices
                                .where((element) =>
                                    element.carType == car!.carTypes.type)
                                .first
                                .price;
                            return Row(
                              children: [
                                Checkbox(
                                  value: servicesList.contains(service),
                                  onChanged: (bool? checked) {
                                    if (checked != null) {
                                      if (checked) {
                                        servicesList.add(service);
                                      } else {
                                        servicesList.remove(service);
                                      }
                                      bookingList = bookingList
                                          .map((e) =>
                                              e.copyWith(isSelected: false))
                                          .toList();
                                      timeInUnit = (servicesList.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.duration) /
                                              30)
                                          .round();
                                      fee = servicesList.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              element.prices
                                                  .where((price) =>
                                                      price.carType ==
                                                      car?.carTypes.type)
                                                  .first
                                                  .price);
                                      setState(() {});
                                    }
                                  },
                                ),
                                Expanded(
                                  flex: 3,
                                  child: COText(service.name),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: COText("$price ฿"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: COText("${service.duration} นาที"),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const COPadding(height: 1),
        Visibility(
          visible: car != null,
          child: Row(
            children: [
              Expanded(
                child: COBox(
                  child: Padding(
                    padding: padding,
                    child: COCenterText(
                      first: "รวมเป็นเงิน",
                      middle: fee.toString(),
                      last: "บาท",
                    ),
                  ),
                ),
              ),
              const COPadding(width: 1),
              Expanded(
                child: COBox(
                  child: Padding(
                    padding: padding,
                    child: COCenterText(
                      first: "ใช้เวลารวม",
                      middle: servicesList
                          .fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.duration,
                          )
                          .toString(),
                      last: "นาที",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const COFloatingButtonPadding(),
      ],
    );
  }

  Widget buttonBuilder({
    bool isDisable = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            child: COElevatedButton(
              onPressed: _onPrevPage,
              child: const COText(
                "ก่อนหน้า",
                color: Colors.white,
              ),
            ),
          ),
        ),
        const COPadding(width: 2),
        Expanded(
          child: SizedBox(
            width: double.maxFinite,
            child: COElevatedButton(
              backgroundColor:
                  isDisable ? inActiveTextColor : buttonPrimaryBackground,
              onPressed: isDisable ? null : _onNextPage,
              child: const COText(
                "ถัดไป",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _page3() {
    return Column(
      children: [
        COBox(
          label: "กรุณาชำระเงินเพื่อยืนยันการจองคิว",
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Image.network(
              widget.store.photoURL,
              width: double.maxFinite,
            ),
          ),
        ),
      ],
    );
  }
}

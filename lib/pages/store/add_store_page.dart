import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/helper/bottomSheet/car_okay_bottom_sheet.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/image_compress.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_picker.dart';
import 'package:car_okay/widgets/dropdown/car_okay_dropdown.dart';
import 'package:car_okay/widgets/maps/car_okay_maps.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  late AuthCubit _authCubit;
  late StoreCubit _storeCubit;

  TextEditingController name = TextEditingController();
  TextEditingController promotion = TextEditingController();
  late GoogleMapController _mapController;

  String startTime = "";
  String endTime = "";
  TextEditingController slot = TextEditingController();
  LatLng? latLng;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();
  File? storeDisplayImage;
  File? qrImage;
  String? storeDisplayImageURL;
  String? qrImageURL;
  late int numberOfService;
  late RateModel? rate;
  late List<String> follows;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _storeCubit = context.read<StoreCubit>();
    name.text = _storeCubit.state.name;
    promotion.text = _storeCubit.state.promotion;
    startTime = _storeCubit.state.open;
    endTime = _storeCubit.state.close;
    slot.text = _storeCubit.state.slot.toString();
    storeDisplayImageURL = _storeCubit.state.displayPhoto.isEmpty
        ? null
        : _storeCubit.state.displayPhoto;
    qrImageURL =
        _storeCubit.state.photoURL.isEmpty ? null : _storeCubit.state.photoURL;
    latLng = LatLng(
      _storeCubit.state.location.latitude,
      _storeCubit.state.location.longitude,
    );
    numberOfService = _storeCubit.state.numberOfService;
    follows = _storeCubit.state.follows;
    rate = _storeCubit.state.rate;
    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    promotion.dispose();
    slot.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onPicker(int index, String target) async {
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
      switch (target) {
        case "qrImage":
          qrImage = compress;
          break;
        case "storeDisplayImage":
          storeDisplayImage = compress;
          break;
        default:
          storeDisplayImage = compress;
          break;
      }
      setState(() {});
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _handleOnPressedSubmit() async {
    if (!_loading) {
      if (validate()) {
        _loading = true;
        await _storeCubit.updateMyStore(
          context,
          userId: _authCubit.getUserId(),
          name: name.text,
          promotion: promotion.text,
          location: latLng!,
          open: startTime,
          close: endTime,
          slot: int.parse(slot.text),
          numberOfService: numberOfService,
          follows: follows,
          rate: rate,
          storeDisplayImage: storeDisplayImage,
          qrImage: qrImage,
          storeDisplayImageUrl: storeDisplayImageURL,
          qrImageUrl: qrImageURL,
        );
      }
    }
    _loading = false;
  }

  bool validate() {
    if (storeDisplayImage == null && storeDisplayImageURL == null) {
      COSnackBar.show(context, title: "กรุณาอัพโหลดรูปภาพร้าน");
      return false;
    }
    if (qrImage == null && qrImageURL == null) {
      COSnackBar.show(context, title: "กรุณาอัพโหลดรูปภาพ QR Code");
      return false;
    }
    if (startTime.isEmpty) return false;
    if (endTime.isEmpty) return false;
    if (int.tryParse(slot.text) == null) {
      COSnackBar.show(context, title: "จำนวนช่องให้บริการต้องเป็นตัวเลข");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const COAppBarText("เพิ่ม/แก้ไขข้อมูลร้านค้า"),
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: defaultPadding * 2,
              children: [
                COImageButton(
                  onTap: () => _buildBottomSheet(
                    context,
                    target: "storeDisplayImage",
                  ),
                  imageFile: storeDisplayImage,
                  photoURL: storeDisplayImageURL,
                  isUser: true,
                ),
                COTextField(
                  label: "ชื่อร้านค้า",
                  hintText: "ชื่อร้านค้า",
                  controller: name,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const COText(
                      "ตำแหน่งที่ตั้ง",
                      bold: true,
                    ),
                    const COPadding(height: 1),
                    InkWell(
                      onTap: () {
                        CONavigator.push(
                          context,
                          COMaps(
                            center: latLng,
                            onSelected: (LatLng selected) {
                              latLng = selected;
                              _mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(target: selected, zoom: 14)),
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: (mapController) {
                                _mapController = mapController;
                                setState(() {});
                              },
                              initialCameraPosition: CameraPosition(
                                target: latLng ??
                                    const LatLng(18.7880315, 98.98563493),
                                zoom: 14,
                              ),
                              compassEnabled: false,
                              mapToolbarEnabled: false,
                              myLocationEnabled: false,
                              markers: {
                                Marker(
                                  markerId: const MarkerId("_init"),
                                  position: LatLng(
                                      latLng?.latitude ?? 18.7880315,
                                      latLng?.longitude ?? 98.98563493),
                                ),
                              },
                            ),
                            Container(
                              height: 200,
                              width: double.maxFinite,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                COTextField(
                  label: "รายละเอียดร้านค้า หรือ โปรโมชั่นพิเศษ",
                  hintText: "กรุณากรอกรายละเอียดร้านค้า หรือ โปรโมชั่นพิเศษ",
                  controller: promotion,
                  maxLines: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CODropdownButton(
                        label: "เวลาเปิด",
                        hint: "เวลาเปิด",
                        value: startTime.isEmpty ? null : startTime,
                        list: timeStringList,
                        onChanged: (String? time) {
                          if (time != null) {
                            if (endTime.isNotEmpty) {
                              int guessStarTimeIndex =
                                  timeStringList.indexOf(time);
                              int endTimeIndex =
                                  timeStringList.indexOf(endTime);
                              if (endTimeIndex > guessStarTimeIndex) {
                                startTime = time;
                                setState(() {});
                              } else {
                                COSnackBar.show(
                                  context,
                                  title: "ท่านเลือกเวลาเปิดเลยเวลาปิด",
                                );
                              }
                            } else {
                              startTime = time;
                              setState(() {});
                            }
                          }
                        },
                      ),
                    ),
                    const COPadding(width: 1),
                    Expanded(
                      child: CODropdownButton(
                        label: "เวลาปิด",
                        hint: "เวลาปิด",
                        value: endTime.isEmpty ? null : endTime,
                        list: timeStringList,
                        onChanged: (String? time) {
                          if (time != null) {
                            if (startTime.isNotEmpty) {
                              int starTimeIndex =
                                  timeStringList.indexOf(startTime);
                              int guessEndTimeIndex =
                                  timeStringList.indexOf(time);
                              if (starTimeIndex < guessEndTimeIndex) {
                                endTime = time;
                                setState(() {});
                              } else {
                                COSnackBar.show(
                                  context,
                                  title: "ท่านเลือกเวลาปิดก่อนเวลาเปิด",
                                );
                              }
                            } else {
                              endTime = time;
                              setState(() {});
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                COTextField(
                  label: "จำนวนช่องให้บริการ",
                  hintText: "กรุณากรอกจำนวนช่องให้บริการ",
                  keyboardType: TextInputType.number,
                  controller: slot,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.maxFinite,
                      child: COText(
                        "แนบรูป QR Payment ของร้านค้า",
                        bold: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const COPadding(height: 1),
                    COImagePicker(
                      onTap: () => _buildBottomSheet(
                        context,
                        target: "qrImage",
                      ),
                      imageFile: qrImage,
                      photoURL: qrImageURL,
                    ),
                    const COPadding(height: 1),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: COElevatedButton(
                    onPressed: _handleOnPressedSubmit,
                    child: const COText(
                      "บันทึกข้อมูล",
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

  Future<void> _buildBottomSheet(
    BuildContext context, {
    required String target,
  }) async {
    return COBottomSheet.bottomSheet(context, [
      SizedBox(
        width: double.maxFinite,
        child: COElevatedButton(
          onPressed: () => _onPicker(0, target),
          child: const COText(
            "ถ่ายรูป",
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(
        width: double.maxFinite,
        child: COElevatedButton(
          onPressed: () => _onPicker(1, target),
          child: const COText(
            "UPLOAD",
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(
        width: double.maxFinite,
        child: COElevatedButton(
          backgroundColor: buttonSecondaryBackground,
          onPressed: () => Navigator.pop(context),
          child: const COText("Cancel"),
        ),
      ),
    ]);
  }
}

import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/bloc/car_cubit.dart';
import 'package:car_okay/bloc/car_types_cubit.dart';
import 'package:car_okay/helper/bottomSheet/car_okay_bottom_sheet.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/car_types_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/image_compress.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_button.dart';
import 'package:car_okay/widgets/dropdown/car_okay_dropdown.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCarPage extends StatefulWidget {
  final Function() onPressedBack;
  const AddCarPage({super.key, required this.onPressedBack});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  late CarCubit _carCubit;
  late AuthCubit _authCubit;
  late CarTypesCubit _carTypesCubit;
  List<String> _brands = [];
  List<String> _types = [];
  List<String> _models = [];
  String? _selectedBrand;
  String? _selectedType;
  String? _selectedModel;
  CarTypes? _selectCarTypes;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  TextEditingController plate = TextEditingController();

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _carCubit = context.read<CarCubit>();
    _carTypesCubit = context.read<CarTypesCubit>();
    //Assume we loaded car types list on previos page(home page)
    _brands = _carTypesCubit.state.map((type) => type.brand).toSet().toList();
    _brands.sort((a, b) => a.toString().compareTo(b.toString()));
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    plate.dispose();
    super.dispose();
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

  void _onBrandChange(String? brand) {
    if (brand != null) {
      if (_selectedBrand != brand) {
        _selectedModel = null;
        _selectedType = null;
        _selectCarTypes = null;
        _types = _carTypesCubit.state
            .where((type) => type.brand == brand)
            .map((filter) => filter.type)
            .toSet()
            .toList();
        _types.sort((a, b) => a.toString().compareTo(b.toString()));
        _models = [];
      }
      _selectedBrand = brand;
      setState(() {});
    }
  }

  void _onTypeChange(String? type) {
    if (type != null) {
      if (_selectedType != type) {
        _selectedModel = null;
        _selectCarTypes = null;
        _models = _carTypesCubit.state
            .where((t) => t.brand == _selectedBrand && t.type == type)
            .map((filter) => filter.model)
            .toSet()
            .toList();
        _models.sort((a, b) => a.toString().compareTo(b.toString()));
      }
      _selectedType = type;
      setState(() {});
    }
  }

  void _onModelChange(String? model) {
    if (model != null) {
      _selectCarTypes = _carTypesCubit.findCarTypes(
        brand: _selectedBrand!,
        type: _selectedType!,
        model: model,
      );
      _selectedModel = model;
      setState(() {});
    }
  }

  void _handleOnPressedSubmit() async {
    if (!_loading && _selectCarTypes != null && plate.text.isNotEmpty) {
      _loading = true;
      await _carCubit.addCarToUser(
        context,
        userId: _authCubit.getUserId(),
        carTypeId: _selectCarTypes!.id,
        plate: plate.text,
        photo: imageFile,
        callback: widget.onPressedBack,
      );
    }
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: () =>
                      COBottomSheet.plain(context, (index) => _onPicker(index)),
                  imageFile: imageFile,
                ),
                CODropdownButton(
                  value: _selectedBrand,
                  list: _brands,
                  label: "ยี่ห้อรถ",
                  hint: "ยี่ห้อรถ",
                  onChanged: _onBrandChange,
                ),
                CODropdownButton(
                  value: _selectedType,
                  list: _types,
                  hint: "ประเภทรถ",
                  label: "ประเภทรถ",
                  onChanged: _onTypeChange,
                ),
                CODropdownButton(
                  value: _selectedModel,
                  list: _models,
                  hint: "รุ่น",
                  label: "รุ่น",
                  onChanged: _onModelChange,
                ),
                COTextField(
                  label: "เลขทะเบียนรถ",
                  hintText: "เลขทะเบียนรถ",
                  controller: plate,
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: padding,
        width: double.maxFinite,
        child: COElevatedButton(
          onPressed: _handleOnPressedSubmit,
          child: const COText(
            "บันทึกข้อมูล",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

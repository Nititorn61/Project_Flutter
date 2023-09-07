import 'package:car_okay/bloc/reservation_cubit.dart';
import 'package:car_okay/bloc/store_cubit.dart';
import 'package:car_okay/models/reservation_model.dart';
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
import 'package:graphic/graphic.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<ReservationModel> _models = [];
  late ReservationCubit _reservationCubit;
  late StoreCubit _storeCubit;
  List<Map<String, Object>> _filtered = [];
  bool _isEmpty = true;

  TextEditingController date = TextEditingController();

  String? _selectedMode;
  String? selectedType;
  final List<String> _mode = <String>[
    "รายวัน",
    "รายเดือน",
    "รายปี",
  ];

  @override
  void initState() {
    _reservationCubit = context.read<ReservationCubit>();
    _storeCubit = context.read<StoreCubit>();
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _models =
        await _reservationCubit.getDone(context, storeId: _storeCubit.state.id);
    setState(() {});
  }

  void updateChartData() {
    if (selectedType != null && _selectedMode != null && date.text.isNotEmpty) {
      switch (_selectedMode) {
        case "รายวัน":
          _filtered = [];
          _isEmpty = true;
          final filterByDate = _models
              .where((element) =>
                  element.date == date.text && element.carType == selectedType)
              .toList();
          List<int> timeCount = timeStringList.map((_) => 0).toList();
          for (var element in filterByDate) {
            timeCount[element.timeSlot] += 1;
          }
          final int startLoop = timeStringList.indexOf(_storeCubit.state.open);
          final int endLoop =
              timeStringList.indexOf(_storeCubit.state.close) + 1;
          Map<String, int> map = {};
          for (var i = startLoop; i < endLoop; i++) {
            map.addAll({timeStringList[i]: timeCount[i]});
          }
          for (var v in map.entries) {
            if (v.value != 0) {
              _isEmpty = false;
            }
            _filtered.add({'time': v.key, 'count': v.value});
          }
          setState(() {});
          break;
        case "รายเดือน":
          _isEmpty = true;
          _filtered = [];
          DateTime dt = DateTime.parse(date.text);
          int year = dt.year;
          List<String> months = [];
          List<int> count = [];
          for (var i = 0; i < 12; i++) {
            months.add((i + 1).toString());
            count.add(0);
          }
          for (ReservationModel doc in _models) {
            final date = doc.date.split("-");
            if (date.first == year.toString()) {
              if (doc.carType == selectedType) {
                _isEmpty = false;
                count[int.parse(date[1]) - 1] += 1;
              }
            }
          }
          for (int i = 0; i < months.length; i++) {
            _filtered.add({'time': monthList[i], 'count': count[i]});
          }
          setState(() {});
          break;
        case "รายปี":
          _filtered = [];
          _isEmpty = true;
          List<String> years = [];
          List<int> count = [];
          DateTime dt = DateTime.parse(date.text);
          for (var i = 0; i < 5; i++) {
            years.add(dt.toIso8601String().split("T").first.split("-").first);
            count.add(0);
            dt = DateTime(dt.year - 1);
          }
          for (ReservationModel doc in _models) {
            final int year = DateTime.parse(doc.date).year;
            final int index = years.indexOf(year.toString());
            if (index != -1 && doc.carType == selectedType) {
              _isEmpty = false;
              count[index] += 1;
            }
          }
          for (int i = 0; i < years.length; i++) {
            _filtered.add({'time': years[i], 'count': count[i]});
          }
          _filtered = _filtered.reversed.toList();
          setState(() {});
          break;
        default:
          break;
      }
      setState(() {});
    }
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
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const COAppBarText("สถิติการใช้งาน"),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CODropdownButton(
                        label: "ช่วงเวลา",
                        hint: "เลือกช่วงเวลา",
                        value: _selectedMode,
                        list: _mode,
                        onChanged: (String? update) {
                          _selectedMode = update;
                          setState(() {});
                        },
                      ),
                    ),
                    const COPadding(width: 1),
                    Expanded(
                      child: COTextField(
                        label: "วันที่",
                        hintText: "เลือกวันที่",
                        controller: date,
                        onPressed: () async {
                          switch (_selectedMode) {
                            case "รายวัน":
                              if (mounted) {
                                DateTime? d = await showDatePicker(
                                  context: context,
                                  initialDate: date.text.isNotEmpty
                                      ? DateTime.parse(date.text)
                                      : DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) {
                                  date.text = d.toString().split(" ").first;
                                  setState(() {});
                                }
                              }
                              break;
                            case "รายเดือน":
                              if (mounted) {
                                DateTime? d = await showMonthPicker(
                                  context: context,
                                  initialDate: date.text.isNotEmpty
                                      ? DateTime.parse(date.text)
                                      : DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) {
                                  date.text = d.toString().split(" ").first;
                                  setState(() {});
                                }
                              }
                              break;
                            case "รายปี":
                              if (mounted) {
                                DateTime? d = await showMonthPicker(
                                  context: context,
                                  initialDate: date.text.isNotEmpty
                                      ? DateTime.parse(date.text)
                                      : DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) {
                                  date.text = d.toString().split(" ").first;
                                  setState(() {});
                                }
                              }
                              break;
                            default:
                              if (mounted) {
                                DateTime? d = await showDatePicker(
                                  context: context,
                                  initialDate: date.text.isNotEmpty
                                      ? DateTime.parse(date.text)
                                      : DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) {
                                  date.text = d.toString().split(" ").first;
                                  setState(() {});
                                }
                              }
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const COPadding(height: 1),
                const COText(
                  "ประเภทรถที่ให้บริการ (*เลือกได้ประเภทเดียว)",
                  bold: true,
                ),
                const COPadding(height: 1),
                ...carTypesList.map(
                  (type) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: selectedType != null
                              ? type == selectedType
                              : false,
                          onChanged: (_) {
                            selectedType = type;
                            setState(() {});
                          },
                        ),
                        COText(type),
                      ],
                    );
                  },
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: COElevatedButton(
                    onPressed: updateChartData,
                    child: const COText(
                      "ค้นหา",
                      color: Colors.white,
                    ),
                  ),
                ),
                _filtered.isNotEmpty
                    ? _isEmpty
                        ? const Center(child: COText(listEmptyMessage))
                        : SizedBox(
                            width: double.maxFinite,
                            height: 400,
                            child: Chart(
                              data: _filtered,
                              variables: {
                                'time': Variable(
                                  accessor: (Map map) => map['time'] as String,
                                ),
                                'count': Variable(
                                  accessor: (Map map) => map['count'] as num,
                                ),
                              },
                              marks: [
                                IntervalMark(
                                  label: LabelEncode(
                                    encoder: (tuple) => Label(
                                      tuple['count'].toString(),
                                    ),
                                  ),
                                ),
                              ],
                              axes: [
                                AxisGuide(
                                  line: PaintStyle(
                                    strokeColor: const Color(0xffe8e8e8),
                                    strokeWidth: 1,
                                  ),
                                  label: LabelStyle(
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      color: textColor,
                                    ),
                                    offset: const Offset(-5, 0),
                                    rotation: 55,
                                  ),
                                ),
                                Defaults.verticalAxis,
                              ],
                              // selections: {'count': PointSelection(dim: Dim.x)},
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:car_okay/models/reservation_model.dart';

List<ReservationModel> filterStatusAndDateTime({
  required String? status,
  required String dateTime,
  required List<ReservationModel> list,
}) {
  DateTime dt = DateTime.parse(dateTime);
  DateTime start =
      DateTime(dt.year, dt.month).subtract(const Duration(days: 1));
  DateTime end = DateTime(dt.year, dt.month + 1);

  final filterByDate = list.where((element) {
    DateTime d = DateTime.parse(element.date);
    return start.isBefore(d) && end.isAfter(d);
  }).toList();

  if (status == "ทั้งหมด") {
    return filterByDate;
  }

  return filterByDate.where((element) => element.status == status).toList();
}

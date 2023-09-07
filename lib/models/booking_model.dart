class BookingModel {
  final String id;
  final String storeId;
  final String date;
  final int slot;
  final List<int> reserved;

  const BookingModel({
    required this.id,
    required this.storeId,
    required this.date,
    required this.slot,
    required this.reserved,
  });

  BookingModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        storeId = json['store_id'] as String,
        slot = json['slot'] as int,
        date = json['date'] as String,
        reserved =
            (json['reserved'] as List<dynamic>).map((e) => e as int).toList();

  Map<String, dynamic> toJson() {
    return {
      "store_id": storeId,
      "date": date,
      "slot": slot,
      "reserved": reserved,
    };
  }
}

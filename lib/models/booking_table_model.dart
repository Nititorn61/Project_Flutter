class BookingTableModel {
  final int index;
  final String time;
  final bool isSelected;
  final bool isSelectAble;
  final bool isShow;

  const BookingTableModel({
    required this.index,
    required this.time,
    this.isSelected = false,
    required this.isSelectAble,
    required this.isShow,
  });

  BookingTableModel copyWith({
    int? index,
    String? time,
    bool? isSelected,
    bool? isSelectAble,
  }) {
    return BookingTableModel(
      index: index ?? this.index,
      time: time ?? this.time,
      isSelected: isSelected ?? this.isSelected,
      isSelectAble: isSelectAble ?? this.isSelectAble,
      isShow: isShow,
    );
  }

  @override
  String toString() {
    return "index:$index time:$time isSelected:$isSelected isSelectAble:$isSelectAble isShow:$isShow\n";
  }
}

class RateModel {
  final double service;
  final double fee;
  final double clean;
  final double haste;

  const RateModel({
    this.service = 0,
    this.fee = 0,
    this.clean = 0,
    this.haste = 0,
  });

  RateModel.fromJson(Map<String, dynamic> json)
      : service = json['service'] as double? ?? 0.0,
        fee = json['fee'] as double? ?? 0.0,
        clean = json['clean'] as double? ?? 0.0,
        haste = json['haste'] as double? ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'fee': fee,
      'clean': clean,
      'haste': haste,
    };
  }
}

// การบริการ 
// ค่าบริการ
// ความสะอาด
// ความรวดเร็ว 
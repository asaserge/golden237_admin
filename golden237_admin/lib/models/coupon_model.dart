class CouponModel{
  String code;
  var start;
  var end;
  String percent;

  CouponModel({
    required this.code,
    required this.start,
    required this.end,
    required this.percent,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'start': start,
    'end': end,
    'percent': percent,
  };

}
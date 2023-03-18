class CouponModel{
  String id;
  String code;
  String start;
  String end;
  int percent;
  String desc;

  CouponModel({
    required this.id,
    required this.code,
    required this.start,
    required this.end,
    required this.desc,
    required this.percent,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'start': start,
    'end': end,
    'desc': desc,
    'percent': percent,
  };

}
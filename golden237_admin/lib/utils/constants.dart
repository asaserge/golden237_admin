import 'package:flutter/material.dart';

const Color primaryColor = Colors.orange;
const String appName = 'Golden 237 Ecommerce';

final colorList = <Color>[
  const Color(0xfffdcb6e),
  const Color(0xff0984e3),
  const Color(0xfffd79a8),
  const Color(0xffe17055),
  const Color(0xff6c5ce7),
];

final gradientList = <List<Color>>[
  [
    const Color.fromRGBO(223, 250, 92, 1),
    const Color.fromRGBO(129, 250, 112, 1),
  ],
  [
    const Color.fromRGBO(129, 182, 205, 1),
    const Color.fromRGBO(91, 253, 199, 1),
  ],
  [
    const Color.fromRGBO(175, 63, 62, 1.0),
    const Color.fromRGBO(254, 154, 92, 1),
  ]
];

final dataMap = <String, double>{
  "Visits": 420,
  "Chats": 54,
  "Online": 12,
  "Orders": 107,
  "Reviews": 109,
};

const sort = [
'Default',
'Latest',
'Cheap',
'Name',
'Older',
'Expensive',
];

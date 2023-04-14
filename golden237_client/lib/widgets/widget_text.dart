import 'package:flutter/cupertino.dart';

class WidgetText extends StatelessWidget {
  const WidgetText({Key? key, required this.text,
    this.font, this.size, this.color, this.maxLines,
  this.alignment}) : super(key: key);
  final String text;
  final String? font;
  final double? size;
  final Color? color;
  final int? maxLines;
  final TextAlign? alignment;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines ?? 2,
        overflow: TextOverflow.ellipsis,
        textAlign: alignment ?? TextAlign.start,
        style: TextStyle(
      fontFamily: font ?? 'montserrat_medium',
      fontSize: size ?? 16,
      color: color,
    ));
  }
}

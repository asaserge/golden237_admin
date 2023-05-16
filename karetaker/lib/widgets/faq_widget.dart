
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:karetaker/widgets/widget_text.dart';

class FaqWidget extends StatelessWidget {
  const FaqWidget({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
        header: WidgetText(text: title, size: 15, font: 'montserrat_bold', maxLines: 5),
        collapsed: const Divider(),
        expanded: Column(
          children: [
            WidgetText(text: subTitle, size: 15, maxLines: 15),
            const Divider(),
            const SizedBox(height: 10)
          ],
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:karetaker/widgets/widget_text.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: WidgetText( text: 'ACCOUNT')
      ),
    );
  }
}

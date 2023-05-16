import 'package:flutter/material.dart';
import 'package:karetaker/widgets/widget_text.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAVORITE'),
      ),
    );
  }
}

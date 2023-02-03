
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key,
  required this.text, required this.image}) : super(key: key);
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0)
      ),
      margin: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image),
            const SizedBox(width: 20),
            Flexible(
              child: Text(text,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

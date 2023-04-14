import 'package:flutter/material.dart';

class DiscoverMusic extends StatelessWidget {
  const DiscoverMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome', style: Theme.of(context)
              .textTheme.titleSmall),
          const SizedBox(height: 5.0),
          Text('Enjoy your favorite music', style: Theme.of(context)
              .textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search music',
                hintStyle: Theme.of(context)
                    .textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none
                )
            ),
          )
        ],
      ),
    );
  }
}

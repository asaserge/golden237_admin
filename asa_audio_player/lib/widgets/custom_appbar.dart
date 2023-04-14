import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget{
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: (){

        },
        child: const Icon(Icons.grid_view_rounded, size: 30.0),
      ),

      actions: [
        InkWell(
          onTap: (){

          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 15.0),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/avatar.png')
                )
            ),
          ),
        )
      ],

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

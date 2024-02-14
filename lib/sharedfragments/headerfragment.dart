import 'package:flutter/material.dart';
import 'package:pilasconelhueco/shared/styles.dart';

class HeaderFragment extends StatelessWidget {
  HeaderFragment({super.key, required this.text});

  late String text;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsPalet.primaryColor,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      height: 100,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsPalet.backgroundColor,
                )),
            Text(text, 
                  style: TextStyle(color: ColorsPalet.backgroundColor, fontWeight: FontWeight.bold, fontSize: 15),),
            const SizedBox(
              width: 70,
            )
          ],
        ),
      ),
    );
  }
}

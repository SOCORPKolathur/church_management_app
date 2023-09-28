import 'package:flutter/material.dart';

import '../constants.dart';

class SnackBarWidget extends StatefulWidget {
  const SnackBarWidget({super.key, required this.text});

  final String text;

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Constants().primaryAppColor, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                spreadRadius: 2.0,
                blurRadius: 8.0,
                offset: Offset(2, 4),
              )
            ],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Constants().primaryAppColor),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(widget.text,
                    style: TextStyle(color: Colors.black)),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
            ],
          )),
    );
  }
}



import 'package:flutter/material.dart';

class CustomBottomNavigatorBar extends StatefulWidget {
  const CustomBottomNavigatorBar({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<CustomBottomNavigatorBar> createState() => _CustomBottomNavigatorBarState();
}

class _CustomBottomNavigatorBarState extends State<CustomBottomNavigatorBar> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          enableFeedback: false,
          onPressed: () {

          },
          icon: widget.pageIndex == 0
              ? const Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 35,
          )
              : const Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        IconButton(
          enableFeedback: false,
          onPressed: () {

          },
          icon: widget.pageIndex == 1
              ? const Icon(
            Icons.work_rounded,
            color: Colors.white,
            size: 35,
          )
              : const Icon(
            Icons.work_outline_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        IconButton(
          enableFeedback: false,
          onPressed: () {
          },
          icon: widget.pageIndex == 2
              ? const Icon(
            Icons.widgets_rounded,
            color: Colors.white,
            size: 35,
          )
              : const Icon(
            Icons.widgets_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        IconButton(
          enableFeedback: false,
          onPressed: () {

          },
          icon: widget.pageIndex == 3
              ? const Icon(
            Icons.person,
            color: Colors.white,
            size: 35,
          )
              : const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 35,
          ),
        ),
      ],
    );
  }
}

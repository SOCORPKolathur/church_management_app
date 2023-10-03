import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/kText.dart';
import '../constants.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: false,
        title: KText(
          text: widget.orderId,
          style: GoogleFonts.openSans(
            fontSize: size.width/22.833333333,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}

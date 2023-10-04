import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/kText.dart';
import '../constants.dart';

class AboutChurchView extends StatefulWidget {
  const AboutChurchView({super.key});

  @override
  State<AboutChurchView> createState() => _AboutChurchViewState();
}

class _AboutChurchViewState extends State<AboutChurchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "About Church",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,color: Colors.white),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: KText(
                  maxLines: null,
                  text: "A common trait of the architecture of many churches is the shape of a cross[12] (a long central rectangle, with side rectangles and a rectangle in front for the altar space or sanctuary). These churches also often have a dome or other large vaulted space in the interior to represent or draw attention to the heavens. Other common shapes for churches include a circle, to represent eternity, or an octagon or similar star shape, to represent the church's bringing light to the world. Another common feature is the spire, a tall tower at the west end of the church or over the crossing.[citation needed]Another common feature of many Christian churches is the eastwards orientation of the front altar.[13] Often, the altar will not be oriented due east but toward the sunrise.[clarification needed] This tradition originated in Byzantium in the 4th century and became prevalent in the West in the 8th and 9th centuries. The old Roman custom of having the altar at the west end and the entrance at the east was sometimes followed as late as the 11th century, even in areas of northern Europe under Frankish rule, as seen in Petershausen (Constance), Bamberg Cathedral, Augsburg Cathedral, Regensburg Cathedral, and Hildesheim Cathedral",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

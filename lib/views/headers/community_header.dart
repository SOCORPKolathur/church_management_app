import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/kText.dart';
import '../../constants.dart';

class CommunityHeader extends StatefulWidget {
  const CommunityHeader({super.key});

  @override
  State<CommunityHeader> createState() => _CommunityHeaderState();
}

class _CommunityHeaderState extends State<CommunityHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment
          .start,
      mainAxisAlignment:
      MainAxisAlignment
          .spaceEvenly,
      children: [
        Padding(
          padding:
          const EdgeInsets
              .all(8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              SizedBox(
                height:
                size.height *
                    0.08,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text:
                'Church Community',
                style: TextStyle(
                  fontSize: Constants().getFontSize(context, "L"),
                  fontFamily: "ArgentumSans",
                ),
              ),
              KText(
                text:
                'Members',
                style: GoogleFonts.amaranth(
                  fontSize: Constants().getFontSize(context, "XL"),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

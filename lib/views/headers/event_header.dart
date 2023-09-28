import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../Widgets/kText.dart';
import '../../constants.dart';

class EventHeader extends StatefulWidget {
  const EventHeader({super.key});

  @override
  State<EventHeader> createState() => _EventHeaderState();
}

class _EventHeaderState extends State<EventHeader> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding:
          const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              SizedBox(
                height:
                size.height * 0.08,
              )
            ],
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              KText(
                text: "Upcoming Events",
                style: TextStyle(
                  fontSize: Constants().getFontSize(context, "L"),
                  fontFamily: "ArgentumSans",
                ),
              ),
              Row(
                children: [
                  Stack(
                    alignment:
                    Alignment.center,
                    children: [
                      Icon(
                        Icons
                            .calendar_today_rounded,
                        size:
                        size.height *
                            0.05,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets
                            .only(
                            top: 8),
                        child: Text(
                          DateFormat("d")
                              .format(DateTime
                              .now()),
                          style: GoogleFonts
                              .amarante(
                            fontSize:
                            size.height *
                                0.028,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  KText(
                    text: DateFormat("MMMM").format(DateTime.now()),
                    style: GoogleFonts.amaranth(
                      fontSize: Constants().getFontSize(context, "XL"),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

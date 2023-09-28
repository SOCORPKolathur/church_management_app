import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/event_model.dart';
import '../services/events_firecrud.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: StreamBuilder(
          stream: EventsFireCrud.fetchEvents(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<EventsModel> events = snapshot.data!;
              return Column(
                children: [
                  for (int i = 0; i < events.length; i++)
                    InkWell(
                      onTap: (){

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 3),
                              blurRadius: 3
                            )
                          ]
                        ),
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.19,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                    events[i].imgUrl!,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: events[i].title!,
                                      style: GoogleFonts.openSans(
                                        fontSize:
                                            Constants().getFontSize(context, 'M'),
                                        color: const Color(0xff000850),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            color: Constants().primaryAppColor),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: events[i].date!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.timelapse,
                                            color: Constants().primaryAppColor),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: events[i].time!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.location_pin,
                                            color: Constants().primaryAppColor),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: events[i].location!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.message_outlined,
                                            color: Constants().primaryAppColor),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: size.width * 0.75,
                                          child: KText(
                                            text: events[i].description!,
                                            style: GoogleFonts.openSans(
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S'),
                                              color: const Color(0xff454545),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }



}

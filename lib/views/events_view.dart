import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/event_model.dart';
import '../services/events_firecrud.dart';
import 'package:intl/intl.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key, required this.phone});

  final String phone;

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Column(
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
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
              ),
              StreamBuilder(
                stream: EventsFireCrud.fetchEvents(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<EventsModel> events = snapshot.data!;
                    return Column(
                      children: [
                        for (int i = 0; i < events.length; i++)
                          InkWell(
                            onTap: (){
                              showEventsPopUp(context, events[i], widget.phone);
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
            ],
          ),
        ),
      ),
    );
  }

  showEventsPopUp(context, EventsModel event,phone) async {
    await updateEventViewCount(event,phone);
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.5,
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
                  height: size.height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        event.imgUrl!,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                            child: const Icon(Icons.cancel)
                        ),
                      ),
                    ],
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
                          text: event.title!,
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
                              text: event.date!,
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
                              text: event.time!,
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
                              text: event.location!,
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
                              width: size.width * 0.55,
                              child: KText(
                                text: event.description!,
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
          )
        );
      },
    );
  }

  updateEventViewCount(EventsModel event,String phone) async {
    List<String> views = [];
    event.views!.forEach((element) {
      views.add(element);
    });
    if(!views.contains(phone)){
      views.add(phone);
    }
    var document = await FirebaseFirestore.instance.collection('Events').doc(event.id).update({
      "views": views
    });
  }


}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../services/events_firecrud.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key, required this.phone});

  final String phone;

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "Events",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, 'L'),
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
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: EventsFireCrud.fetchEvents(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<EventsModel> events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (ctx, j) {
                  return VisibilityDetector(
                    key: const Key('my-widget-key'),
                    onVisibilityChanged: (VisibilityInfo visibilityInfo){
                      var visiblePercentage = visibilityInfo.visibleFraction;
                      if(visiblePercentage == 1.0){
                        updateEventViewCount(events[j], widget.phone);
                      }
                    },
                    child: Container(
                      width: size.width * 0.88,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 3),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              showImageModel(context, events[j].imgUrl!);
                            },
                            child: Container(
                              height: size.height * 0.16,
                              width: size.width * 0.37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                    events[j].imgUrl!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.43,
                            child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height/28.866666667,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: KText(
                                      text: events[j].title!,
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'M'),
                                        color: const Color(0xff000850),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            color: Constants().primaryAppColor),
                                        SizedBox(width: size.width/82.2),
                                        KText(
                                          text: events[j].date!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height/173.2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Row(
                                      children: [
                                        Icon(Icons.timelapse,
                                            color: Constants().primaryAppColor),
                                        SizedBox(width: size.width/82.2),
                                        KText(
                                          text: events[j].time!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height/173.2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_pin,
                                            color: Constants().primaryAppColor),
                                        SizedBox(width: size.width/82.2),
                                        KText(
                                          text: events[j].location!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height/173.2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: Row(
                                      children: [
                                        Icon(Icons.message_outlined,
                                            color: Constants().primaryAppColor),
                                        SizedBox(width: size.width/82.2),
                                        KText(
                                          text: events[j].description!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff454545),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
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


  showImageModel(context, String imgUrl) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(
            imgUrl,
          ),
        );
      },
    );
  }
}

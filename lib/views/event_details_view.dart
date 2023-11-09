import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/constants.dart';
import 'package:church_management_client/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import '../Widgets/kText.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({super.key,required this.id, required this.userId});

  final String id;
  final String userId;

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Events').doc(widget.id).snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              EventsModel event = EventsModel.fromJson(snapshot.data!.data() as Map<String,dynamic>);
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      showImageModel(context, event.imgUrl!);
                    },
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                            event.imgUrl!,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              elevation: 2,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height/173.2),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: KText(
                                  text: event.title!,
                                  style: GoogleFonts.openSans(
                                    fontSize: Constants().getFontSize(context, 'M'),
                                    color: const Color(0xff000850),
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                    Icon(Icons.date_range,
                                        color: Constants().primaryAppColor),
                                    SizedBox(width: size.width/82.2),
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
                              ),
                            ),
                            SizedBox(height: size.height/173.2),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.message_outlined,
                                        color: Constants().primaryAppColor),
                                    SizedBox(width: size.width/82.2),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        event.description!,
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
                              ),
                            ),
                          ],
                        ),
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
      floatingActionButton: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Events').doc(widget.id).snapshots(),
        builder: (ctx, snap){
          if(snap.hasData){
            EventsModel event = EventsModel.fromJson(snap.data!.data() as Map<String,dynamic>);
            return InkWell(
              onTap: (){
                updateEventRegistration(event,widget.userId);
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 45,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      event.registeredUsers!.contains(widget.userId) ? 'Registered for this Event' : "Register for this Event",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  updateEventRegistration(EventsModel event,String id) async {
    List<String> registeredUsers = [];
    event.registeredUsers!.forEach((element) {
      registeredUsers.add(element);
    });
    if(!registeredUsers.contains(id)){
      registeredUsers.add(id);
    }
    var document = await FirebaseFirestore.instance.collection('Events').doc(event.id).update({
      "registeredUsers": registeredUsers
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

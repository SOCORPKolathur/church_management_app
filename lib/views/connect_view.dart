import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/event_model.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({super.key, required this.phone,required this.userDocId,required this.uid});

  final String phone;
  final String userDocId;
  final String uid;

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {

  navigateToChatPage(String collection,String title){
      Navigator.push(context, MaterialPageRoute(builder: (ctx)=> ChatView(title: title,userDocId: widget.userDocId,uid: widget.uid,collection:collection)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text(
          "Connect",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChurchChat")
                    .orderBy("time")
                    .snapshots(),
                builder: (ctx,snap1){
                  if(snap1.hasData){
                    return InkWell(
                      onTap: (){
                        navigateToChatPage('ChurchChat','Church');
                      },
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          radius: 25, child: Icon(Icons.church,size: size.width/11, color: Colors.white),
                        ),
                        title: const Text(
                          "Church",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Text(
                              snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['submittime'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("MembersChat")
                    .orderBy("time")
                    .snapshots(),
                builder: (ctx,snap1){
                  if(snap1.hasData){
                    return InkWell(
                      onTap: (){
                        navigateToChatPage('MembersChat','Members');
                      },
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          radius: 25, child: Icon(Icons.groups,size: size.width/11, color: Colors.white),
                        ),
                        title: const Text(
                          "Members",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          snap1.data!.docs.isEmpty ? "" :snap1.data!.docs.last['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Text(
                              snap1.data!.docs.isEmpty ? "" :snap1.data!.docs.last['submittime'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("BloodRequirementChat")
                    .orderBy("time")
                    .snapshots(),
                builder: (ctx,snap1){
                  if(snap1.hasData){
                    return InkWell(
                      onTap: (){
                        navigateToChatPage('BloodRequirementChat','Blood Requirement');
                      },
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          radius: 25, child: Icon(Icons.bloodtype,size: size.width/11, color: Colors.white),
                        ),
                        title: const Text(
                          "Blood Requirement",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          snap1.data!.docs.last['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Text(
                              snap1.data!.docs.last['submittime'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ClansChat")
                    .orderBy("time")
                    .snapshots(),
                builder: (ctx,snap1){
                  if(snap1.hasData){
                    return InkWell(
                      onTap: (){
                        navigateToChatPage('ClansChat','Clans');
                      },
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          radius: 25, child: Icon(Icons.bookmark_add,size: size.width/11, color: Colors.white),
                        ),
                        title: const Text(
                          "Clans",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Text(
                              snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['submittime'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChorusChat")
                    .orderBy("time")
                    .snapshots(),
                builder: (ctx,snap1){
                  if(snap1.hasData){
                    return InkWell(
                      onTap: (){
                        navigateToChatPage('ChorusChat','Quire');
                      },
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          radius: 25, child: Icon(Icons.music_video_outlined,size: size.width/11, color: Colors.white),
                        ),
                        title: const Text(
                          "Quire",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.01),
                            Text(
                              snap1.data!.docs.isEmpty ? "" : snap1.data!.docs.last['submittime'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              )
            ],
          ),
        ),
      )
    );
    // return Container(
    //   color: Colors.white,
    //   child: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    //       child: Column(
    //         children: [
    //           Column(
    //             crossAxisAlignment:
    //             CrossAxisAlignment.start,
    //             mainAxisAlignment:
    //             MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Padding(
    //                 padding:
    //                 const EdgeInsets.all(8.0),
    //                 child: Column(
    //                   crossAxisAlignment:
    //                   CrossAxisAlignment.start,
    //                   children: [
    //                     KText(
    //                       text: "Upcoming Events",
    //                       style: TextStyle(
    //                         fontSize: Constants().getFontSize(context, "L"),
    //                         fontFamily: "ArgentumSans",
    //                       ),
    //                     ),
    //                     Row(
    //                       children: [
    //                         Stack(
    //                           alignment:
    //                           Alignment.center,
    //                           children: [
    //                             Icon(
    //                               Icons
    //                                   .calendar_today_rounded,
    //                               size:
    //                               size.height *
    //                                   0.05,
    //                             ),
    //                             Padding(
    //                               padding:
    //                               const EdgeInsets
    //                                   .only(
    //                                   top: 8),
    //                               child: Text(
    //                                 DateFormat("d")
    //                                     .format(DateTime
    //                                     .now()),
    //                                 style: GoogleFonts
    //                                     .amarante(
    //                                   fontSize:
    //                                   size.height *
    //                                       0.028,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         const SizedBox(width: 10),
    //                         KText(
    //                           text: DateFormat("MMMM").format(DateTime.now()),
    //                           style: GoogleFonts.amaranth(
    //                             fontSize: Constants().getFontSize(context, "XL"),
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //           StreamBuilder(
    //             stream: EventsFireCrud.fetchEvents(),
    //             builder: (ctx, snapshot) {
    //               if (snapshot.hasData) {
    //                 List<EventsModel> events = snapshot.data!;
    //                 return Column(
    //                   children: [
    //                     for (int i = 0; i < events.length; i++)
    //                       InkWell(
    //                         onTap: (){
    //                           showEventsPopUp(context, events[i], widget.phone);
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(10),
    //                             boxShadow: const [
    //                               BoxShadow(
    //                                 color: Colors.black26,
    //                                 offset: Offset(2, 3),
    //                                 blurRadius: 3
    //                               )
    //                             ]
    //                           ),
    //                           margin: const EdgeInsets.all(8),
    //                           child: Column(
    //                             children: [
    //                               Container(
    //                                 height: size.height * 0.19,
    //                                 width: double.infinity,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: const BorderRadius.only(
    //                                     topLeft: Radius.circular(10),
    //                                     topRight: Radius.circular(10),
    //                                   ),
    //                                   image: DecorationImage(
    //                                     fit: BoxFit.fill,
    //                                     image: CachedNetworkImageProvider(
    //                                       events[i].imgUrl!,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 width: size.width,
    //                                 child: Padding(
    //                                   padding: const EdgeInsets.all(8),
    //                                   child: Column(
    //                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                     children: [
    //                                       KText(
    //                                         text: events[i].title!,
    //                                         style: GoogleFonts.openSans(
    //                                           fontSize:
    //                                               Constants().getFontSize(context, 'M'),
    //                                           color: const Color(0xff000850),
    //                                           fontWeight: FontWeight.bold,
    //                                         ),
    //                                       ),
    //                                       const SizedBox(height: 10),
    //                                       Row(
    //                                         children: [
    //                                           Icon(Icons.date_range,
    //                                               color: Constants().primaryAppColor),
    //                                           const SizedBox(width: 5),
    //                                           KText(
    //                                             text: events[i].date!,
    //                                             style: GoogleFonts.openSans(
    //                                               fontSize: Constants()
    //                                                   .getFontSize(context, 'S'),
    //                                               color: const Color(0xff454545),
    //                                               fontWeight: FontWeight.w600,
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       const SizedBox(height: 10),
    //                                       Row(
    //                                         children: [
    //                                           Icon(Icons.timelapse,
    //                                               color: Constants().primaryAppColor),
    //                                           const SizedBox(width: 5),
    //                                           KText(
    //                                             text: events[i].time!,
    //                                             style: GoogleFonts.openSans(
    //                                               fontSize: Constants()
    //                                                   .getFontSize(context, 'S'),
    //                                               color: const Color(0xff454545),
    //                                               fontWeight: FontWeight.w600,
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       const SizedBox(height: 10),
    //                                       Row(
    //                                         children: [
    //                                           Icon(Icons.location_pin,
    //                                               color: Constants().primaryAppColor),
    //                                           const SizedBox(width: 5),
    //                                           KText(
    //                                             text: events[i].location!,
    //                                             style: GoogleFonts.openSans(
    //                                               fontSize: Constants()
    //                                                   .getFontSize(context, 'S'),
    //                                               color: const Color(0xff454545),
    //                                               fontWeight: FontWeight.w600,
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       const SizedBox(height: 10),
    //                                       Row(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Icon(Icons.message_outlined,
    //                                               color: Constants().primaryAppColor),
    //                                           const SizedBox(width: 5),
    //                                           SizedBox(
    //                                             width: size.width * 0.75,
    //                                             child: KText(
    //                                               text: events[i].description!,
    //                                               style: GoogleFonts.openSans(
    //                                                 fontSize: Constants()
    //                                                     .getFontSize(context, 'S'),
    //                                                 color: const Color(0xff454545),
    //                                                 fontWeight: FontWeight.w600,
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       const SizedBox(height: 15),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       )
    //                   ],
    //                 );
    //               }
    //               return Container();
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  showEventsPopUp(context, EventsModel event, phone) async {
    await updateEventViewCount(event, phone);
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
                        blurRadius: 3)
                  ]),
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
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.cancel)),
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
                              fontSize: Constants().getFontSize(context, 'M'),
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
                                  fontSize:
                                      Constants().getFontSize(context, 'S'),
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
                                  fontSize:
                                      Constants().getFontSize(context, 'S'),
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
                                  fontSize:
                                      Constants().getFontSize(context, 'S'),
                                  color: const Color(0xff454545),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.message_outlined,
                                  color: Constants().primaryAppColor),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: size.width * 0.55,
                                child: KText(
                                  text: event.description!,
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                        Constants().getFontSize(context, 'S'),
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
            ));
      },
    );
  }

  updateEventViewCount(EventsModel event, String phone) async {
    List<String> views = [];
    event.views!.forEach((element) {
      views.add(element);
    });
    if (!views.contains(phone)) {
      views.add(phone);
    }
    var document = await FirebaseFirestore.instance
        .collection('Events')
        .doc(event.id)
        .update({"views": views});
  }
}

class ChatGroupModel {
  ChatGroupModel(this.name, this.icon, this.date, this.time, this.lastMsg);

  String name;
  String lastMsg;
  String time;
  String date;
  IconData icon;
}

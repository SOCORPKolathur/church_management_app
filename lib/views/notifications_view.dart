import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Widgets/kText.dart';
import '../constants.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key, required this.userDocId});

  final String userDocId;

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "Notifications",
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userDocId)
            .collection("Notifications")
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VisibilityDetector(
                    key: const Key('my-widget-key'),
                    onVisibilityChanged: (VisibilityInfo visibilityInfo){
                      var visiblePercentage = visibilityInfo.visibleFraction * 6;
                      print(visiblePercentage);
                      //if(visiblePercentage >= 0.2){
                        if(!snap.data!.docs[i]['isViewed']) {
                          updateNottificationStatus(snap.data!.docs[i].id);
                        }
                      //}
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !snap.data!.docs[i]['isViewed'],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                        child: Text("New"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snap.data!.docs[i]['date'],
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  snap.data!.docs[i]['time'],
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snap.data!.docs[i]['subject'],
                              style: GoogleFonts.openSans(
                                color: const Color(0xff000850),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snap.data!.docs[i]['content'],
                              style: GoogleFonts.openSans(
                                color: const Color(0xff454545),
                                fontSize: Constants().getFontSize(context, "S"),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  updateNottificationStatus(String id)  {
    print(id);
     FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userDocId)
        .collection("Notifications").doc(id).update({
      "isViewed" : true
    });
     setState(() {});
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/notice_model.dart';
import '../services/notice_firecrud.dart';

class NoticesListView extends StatefulWidget {
  NoticesListView({super.key, required this.phone, required this.scrollController, required this.hasScroll});

  final String phone;
  final ScrollController scrollController;
  bool hasScroll;

  @override
  State<NoticesListView> createState() => _NoticesListViewState();
}

class _NoticesListViewState extends State<NoticesListView> {

  bool hasScroll = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Constants().primaryAppColor,
      //   centerTitle: true,
      //   title: KText(
      //     text: "Notices",
      //     style: GoogleFonts.openSans(
      //       color: Colors.white,
      //       fontSize: Constants().getFontSize(context, 'L'),
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Icon(Icons.arrow_back,color: Colors.white),
      //   ),
      // ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: NoticeFireCrud.fetchNotice(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<NoticeModel> notices = snapshot.data!;
              return ListView.builder(
                physics: widget.hasScroll ? ScrollPhysics() : NeverScrollableScrollPhysics(),
                controller: widget.scrollController,
                itemCount: notices.length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () {
                      showNoticesPopUp(context, notices[i]);
                    },
                    child: VisibilityDetector(
                      key: Key('my-widget-key2 $i'),
                      onVisibilityChanged: (VisibilityInfo visibilityInfo){
                        var visiblePercentage = visibilityInfo.visibleFraction;
                          updateNoticeViewCount(notices[i], widget.phone);
                        if(i == 0 && (!hasScroll && visiblePercentage == 1.0) || (hasScroll && visiblePercentage == 1.0)) {
                          setState(() {
                            hasScroll = false;
                          });
                        }
                        if(i == notices.length-1) {
                          setState(() {
                            hasScroll = true;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notices[i].date!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notices[i].time!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height/86.6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: notices[i].title!,
                                  style: GoogleFonts.openSans(
                                    fontSize: size.width/20.55,
                                    color: const Color(0xff000850),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: size.height/173.2),
                            KText(
                              text: notices[i].description!,
                              style: GoogleFonts.openSans(
                                fontSize: size.width/25.6875,
                                color: const Color(0xff454545),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: size.height/173.2),
                          ],
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
      ),
    );
  }

  showNoticesPopUp(context, NoticeModel notice) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: notice.title!,
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffF7FAFC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notice.date!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notice.time!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: KText(
                                      text: notice.description!,
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  updateNoticeViewCount(NoticeModel notice,String phone) async {
    List<String> views = [];
    notice.views!.forEach((element) {
      views.add(element);
    });
    if(!views.contains(phone)){
      views.add(phone);
    }
    var document = await FirebaseFirestore.instance.collection('Notices').doc(notice.id).update({
      "views": views
    });
  }
}

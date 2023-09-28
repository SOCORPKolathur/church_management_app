import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/notice_model.dart';
import '../services/notice_firecrud.dart';

class NoticesListView extends StatefulWidget {
  const NoticesListView({super.key});

  @override
  State<NoticesListView> createState() => _NoticesListViewState();
}

class _NoticesListViewState extends State<NoticesListView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: KText(
          text: "Notices",
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: NoticeFireCrud.fetchNotice(),
          builder: (ctx,snapshot){
            if(snapshot.hasData){
              List<NoticeModel> notices = snapshot.data!;
              return ListView.builder(
                itemCount: notices.length,
                itemBuilder: (ctx,i){
                  return InkWell(
                    onTap: (){
                      showNoticesPopUp(context,notices[i]);
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
                                  fontSize: Constants().getFontSize(context, "S"),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                notices[i].time!,
                                style: GoogleFonts.openSans(
                                  color: Colors.grey,
                                  fontSize: Constants().getFontSize(context, "S"),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: notices[i].title!,
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  color: const Color(0xff000850),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          KText(
                            text: notices[i].description!,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: const Color(0xff454545),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              );
            }return Container();
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
                            setState(() {

                            });
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
                                    fontSize: Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notice.time!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: Constants().getFontSize(context, "S"),
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
                                        fontSize:
                                        Constants().getFontSize(context, 'S'),
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
}

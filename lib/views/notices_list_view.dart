import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
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
                  return Container(
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
                  );
                },
              );
            }return Container();
          },
        ),
      ),
    );
  }
}

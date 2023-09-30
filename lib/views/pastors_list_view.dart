import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import '../Widgets/kText.dart';
import '../constants.dart';

class PastorsListView extends StatefulWidget {
  const PastorsListView({super.key});

  @override
  State<PastorsListView> createState() => _PastorsListViewState();
}

class _PastorsListViewState extends State<PastorsListView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Pastors",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Pastors').snapshots(),
        builder: (ctx,snap){
          if(snap.hasData){
            var pastors = snap.data!.docs;
            return ListView.builder(
              itemCount: pastors.length,
              itemBuilder: (ctx,j){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                  width: size.width * 0.9,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              showImageModel(context, snap.data!.docs[j]["imgUrl"]);
                            },
                            child: Container(
                              height: size.height * 0.16,
                              width: size.width * 0.37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                      snap.data!.docs[j]["imgUrl"]!
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: size.width * 0.43,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: size.width * 0.43,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: SizedBox(
                                        width: size.width * 0.5,
                                        child: Text(
                                          snap.data!.docs[j]["firstName"]+" "+snap.data!.docs[j]["lastName"],
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'S'),
                                            color: const Color(0xff000850),
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                          Icon(Icons.phone,
                                              color: Constants()
                                                  .primaryAppColor),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: KText(
                                              text: snap.data!.docs[j]["phone"],
                                              style: GoogleFonts.openSans(
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S'),
                                                color:
                                                const Color(0xff454545),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: SizedBox(
                                      width: size.width * 0.5,
                                      child: Row(
                                        children: [
                                          Icon(Icons.alternate_email,
                                              color: Constants()
                                                  .primaryAppColor),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              snap.data!.docs[j]["email"],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.openSans(
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S'),
                                                color:
                                                const Color(0xff454545),
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                );
              },
            );
          }return Container();
        },
      )
    );
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

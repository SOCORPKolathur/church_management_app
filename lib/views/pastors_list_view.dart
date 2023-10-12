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
        centerTitle: true,
        title: Text("Pastors",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,color: Colors.white),
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
                  child: InkWell(
                    onTap: (){
                      showPastorPopUp(context,snap.data!.docs[j]);
                    },
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
                                      height: size.height/28.866666667,
                                      width: size.width * 0.43,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                            SizedBox(width: size.width/82.2),
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
                                    SizedBox(height: size.height/173.2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: SizedBox(
                                        width: size.width * 0.5,
                                        child: Row(
                                          children: [
                                            Icon(Icons.alternate_email,
                                                color: Constants()
                                                    .primaryAppColor),
                                            SizedBox(width: size.width/82.2),
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
                  ),
                );
              },
            );
          }return Container();
        },
      )
    );
  }

  showPastorPopUp(context, var data) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.5,
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                          text: data["firstName"]!+data["lastName"]!,
                          textOverflow: TextOverflow.ellipsis,
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
                        InkWell(
                          onTap: () {
                            showImageModel(context, data["imgUrl"]!);
                          },
                          child: Container(
                            height: size.height * 0.26,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                  data["imgUrl"]!
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height/173.2),
                        SizedBox(
                          width: size.width,
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height/173.2),
                              SizedBox(
                                height: size.height/28.866666667,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: KText(
                                    text: data["firstName"]!+data["lastName"]!,
                                    style: GoogleFonts.openSans(
                                      fontSize: Constants()
                                          .getFontSize(context, 'M'),
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
                                      Icon(Icons.phone,
                                          color: Constants().primaryAppColor),
                                      SizedBox(width: size.width/82.2),
                                      KText(
                                        text: data["phone"]!,
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
                              SizedBox(height: size.height/173.2),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: size.width * 0.5,
                                  child: Row(
                                    children: [
                                      Icon(Icons.alternate_email,
                                          color: Constants().primaryAppColor),
                                      SizedBox(width: size.width/82.2),
                                      KText(
                                        text: data["email"]!,
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
                ),
              ],
            ),
          ),
        );
      },
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class MembersPreviuosPayments extends StatefulWidget {
  const MembersPreviuosPayments({required this.uid});

  final String uid;

  @override
  State<MembersPreviuosPayments> createState() => _MembersPreviuosPaymentsState();
}

class _MembersPreviuosPaymentsState extends State<MembersPreviuosPayments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text(
          "Previous Reports",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Members').doc(widget.uid).collection('Membership').orderBy("timestamp", descending: true).snapshots(),
        builder: (ctx, snap){
          if(snap.hasData){
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (ctx, i) {
                var data = snap.data!.docs[i];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: width / 1.1,
                        height: height / 9.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: width / 29,
                                    top: height / 94.5,
                                    bottom: height / 151.2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width / 1.5,
                                        child: Text(
                                          data.get("month"),
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: width / 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: height / 130.6),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: width / 30,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Payed On : " + data.get("payOn"),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: width / 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Center(
                              child: Material(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  topLeft: Radius.circular(100),
                                ),
                                elevation: 2,
                                child: Container(
                                  height: height / 25.3,
                                  width: width / 3.88,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      topLeft: Radius.circular(100),
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Paid",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: width / 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }return Container(
            child: Center(
              child: Lottie.asset(
                'assets/churchLoading.json',
                fit: BoxFit.contain,
                height: size.height * 0.4,
                width: size.width * 0.7,
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/kText.dart';
import '../constants.dart';

class AboutChurchView extends StatefulWidget {
  const AboutChurchView({super.key});

  @override
  State<AboutChurchView> createState() => _AboutChurchViewState();
}

class _AboutChurchViewState extends State<AboutChurchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "About Church",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
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
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('ChurchDetails').snapshots(),
            builder: (ctx,snap){
              if(snap.hasData){
                var data = snap.data!.docs.first;
                data.get("aboutChurch")[0]['about'];
                return ListView.builder(
                  itemCount: data.get("aboutChurch").length,
                  itemBuilder: (ctx, i){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    data.get("aboutChurch")[i]['img']
                                )
                              )
                            ),
                          ),
                          SizedBox(height: 15),
                          KText(
                              text: data.get("aboutChurch")[i]['about'],
                              maxLines: null,
                              style: TextStyle(

                              )
                          )
                        ],
                      ),
                    );
                  },
                );
              }return Container();
            },
          )
        ),
      ),
    );
  }
}

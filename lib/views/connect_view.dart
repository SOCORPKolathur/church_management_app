import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

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

  UserModel currentUser = UserModel();

  setCurrentUser(UserModel user){
    currentUser = user;
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
      body: StreamBuilder(
        stream: UserFireCrud.fetchUsersWithId(widget.uid),
        builder: (ctx, snaps){
          if(snaps.hasData){
            UserModel user = snaps.data!;
            setCurrentUser(user);
            return SingleChildScrollView(
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
                                backgroundColor: Constants().primaryAppColor,
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
                            onTap: () async {
                              bool isTrue = false;
                              var memberDocument = await FirebaseFirestore.instance.collection('Members').get();
                              memberDocument.docs.forEach((element) {
                                if(element['phone'] == currentUser.phone){
                                  isTrue = true;
                                }
                              });
                              if(isTrue){
                                navigateToChatPage('MembersChat','Members');
                              }else{
                                showInvalidAccessPopUp(context,"You are not a member");
                              }
                            },
                            child: ListTile(
                              style: ListTileStyle.list,
                              leading: CircleAvatar(
                                radius: 25, child: Icon(Icons.groups,size: size.width/11, color: Colors.white),
                                backgroundColor: Constants().primaryAppColor,
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
                                backgroundColor: Constants().primaryAppColor,
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
                            onTap: () async {
                              bool isTrue = false;
                              var clanDocument = await FirebaseFirestore.instance.collection('Clans').get();
                              clanDocument.docs.forEach((element) {
                                if(element['phone'] == currentUser.phone){
                                  isTrue = true;
                                }
                              });
                              if(isTrue){
                                navigateToChatPage('ClansChat','Clans');
                              }else{
                                showInvalidAccessPopUp(context,"You are not a clan member");
                              }
                            },
                            child: ListTile(
                              style: ListTileStyle.list,
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Constants().primaryAppColor, child: Icon(Icons.bookmark_add,size: size.width/11, color: Colors.white),
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
                            onTap: () async {
                              bool isTrue = false;
                              var clanDocument = await FirebaseFirestore.instance.collection('Chorus').get();
                              clanDocument.docs.forEach((element) {
                                if(element['phone'] == currentUser.phone){
                                  isTrue = true;
                                }
                              });
                              if(isTrue){
                                navigateToChatPage('ChorusChat','Quire');
                              }else{
                                showInvalidAccessPopUp(context,"You are not a Quire member");
                              }
                            },
                            child: ListTile(
                              style: ListTileStyle.list,
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Constants().primaryAppColor, child: Icon(Icons.music_video_outlined,size: size.width/11, color: Colors.white),
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
            );
          }return Container();
        },
      )
    );
  }

  showInvalidAccessPopUp(context, String message) async {;
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: size.height * 0.4,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                    width: double.infinity,
                    child: Center(
                      child: Lottie.asset(
                        'assets/lock.json',
                        fit: BoxFit.contain,
                        height: size.height * 0.4,
                        width: size.width * 0.7,
                      ),
                    )
                  ),
                  KText(
                    text: "SORRY..",
                    style: GoogleFonts.openSans(
                      fontSize: Constants().getFontSize(context, 'M'),
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KText(
                    text: message,
                    style: GoogleFonts.openSans(
                      fontSize: Constants().getFontSize(context, 'S'),
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height*0.01),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: size.height * 0.055,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "OK",
                          style: GoogleFonts.poppins(
                            fontSize: Constants().getFontSize(context, "S"),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.01),
                ],
              ),
            ));
      },
    );
  }


}

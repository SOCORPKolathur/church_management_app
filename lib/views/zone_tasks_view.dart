import 'dart:convert';
import 'package:church_management_client/Widgets/kText.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:church_management_client/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class ZoneTaskView extends StatefulWidget {
  ZoneTaskView({required this.userDocId,required this.zoneDocId,required this.zoneId, required this.uid,required this.title});
  final String userDocId;
  final String zoneDocId;
  final String zoneId;
  final String uid;
  final String title;
  @override
  ZoneTaskViewState createState() => ZoneTaskViewState();
}

class ZoneTaskViewState extends State<ZoneTaskView> {

  bool isLeader = false;
  ScrollController _scrollController = new ScrollController();
  TextEditingController chatMessage = new TextEditingController();
  TextEditingController feedBackController = new TextEditingController();

  UserModel currentUser = UserModel();

  setCurrentUser(UserModel user){
    currentUser = user;
    checkIsLeader(currentUser.phone!);
  }

  checkIsLeader(String phone) async {
    var zoneDoc = await FirebaseFirestore.instance.collection('Zones').doc(widget.zoneDocId).get();
    if(zoneDoc.get("leaderPhone") == phone){
      setState(() {
        isLeader = true;
      });
    }else{
      setState(() {
        isLeader = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Constants().primaryAppColor,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.map,
                size: width/13, color: Constants().primaryAppColor,
              ),
            ),
            SizedBox(width: width/41.1),
            Text(
              widget.title,
              style: GoogleFonts.amaranth(
                color: Colors.white,
                fontSize: Constants().getFontSize(context, "L"),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 0,
        leadingWidth: width/13.7,
        leading: SizedBox(
            width: width/20.55,
            child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: width/41.1,right: width/41.1),
                  child: const Icon(Icons.arrow_back,color: Colors.white),
                )
            )
        ),
      ),
      body: FutureBuilder(
        //stream: UserFireCrud.fetchUsersWithId(widget.uid),
        future: FirebaseFirestore.instance.collection('Users').where("id",isEqualTo: widget.uid).get(),
        builder: (ctx, snaps){
          if(snaps.hasData){
            UserModel user = UserModel.fromJson(snaps.data!.docs.first.data());
            setCurrentUser(user);
            return OfflineBuilder(
              connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                  ) {
                if (connectivity == ConnectivityResult.none) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 15.18, horizontal: width / 7.84),
                    child: Center(
                      child: Text(
                        "Oops,\nYou're offline",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 7.84,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  return child;
                }
              },
              builder: (BuildContext context) {
                return
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Tasks').where("zoneId",isEqualTo: widget.zoneId).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(/*vertical: height / 37.95,*/ horizontal: width / 19.6),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: <Widget>[
                                SingleChildScrollView(
                                  reverse: true,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      scrollDirection: Axis.vertical,
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data = snapshot.data!.docs[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Material(
                                            elevation: 2,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    KText(
                                                        text: data.get("taskName"),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w700,
                                                          color: Constants().primaryAppColor,
                                                        ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    KText(
                                                      text: "Description :",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    KText(
                                                      text: data.get("taskDescription"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        KText(
                                                          text: "Status : ",
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black54,
                                                          ),
                                                        ),
                                                        KText(
                                                          text: data.get("status"),
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w400,
                                                            color: data.get("status").toString().toLowerCase() == "completed" ? Colors.green : Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      visible: data.get("status").toString().toLowerCase() == "completed",
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 10),
                                                          KText(
                                                            text: "Feedback :",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black54,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          SizedBox(
                                                            width: width * 0.55,
                                                            child: KText(
                                                              text: data.get("feedback"),
                                                              style: GoogleFonts.poppins(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: (isLeader && data.get("status").toString().toLowerCase() != "completed"),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10),
                                                            child: InkWell(
                                                              onTap: (){
                                                                feedBackController.clear();
                                                                sendFeedBack(
                                                                  data.id
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: width * 0.6,
                                                                decoration: BoxDecoration(
                                                                  color: Constants().primaryAppColor,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Center(
                                                                  child: KText(
                                                                    text: "Submit Feedback",
                                                                    style: GoogleFonts.poppins(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }return Container();
                    },
                  );
              },
            );
          }return Container();
        },
      ),
    );
  }

  sendFeedBack(String id) async {
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
                        text: "Feedback",
                        style: GoogleFonts.openSans(
                          fontSize: Constants().getFontSize(context, 'M'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            feedBackController.text = "";
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
                      )),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Description",
                                style: GoogleFonts.openSans(
                                  fontSize:
                                  Constants().getFontSize(context, 'S'),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Container(
                                  height: size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    maxLines: null,
                                    controller: feedBackController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(7)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              //if (feedBackController.text != "") {
                                updateTask(id: id, feedBack: feedBackController.text);
                              //}
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                                child: Center(
                                  child: KText(
                                    text: "Update",
                                    style: GoogleFonts.openSans(
                                      fontSize: Constants()
                                          .getFontSize(context, 'S'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                feedBackController.text = "";
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                                child: Center(
                                  child: KText(
                                    text: "Cancel",
                                    style: GoogleFonts.openSans(
                                      fontSize: Constants()
                                          .getFontSize(context, 'S'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  updateTask({required String id,required String feedBack}){
    Size size = MediaQuery.of(context).size;
    FirebaseFirestore.instance.collection('Tasks').doc(id).update({
      "feedback" : feedBack,
      "status" : "Completed"
    }).whenComplete(() async {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Feedback updated successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      feedBackController.clear();
      Navigator.pop(context);
    }).onError((error, stackTrace) async {
      await CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: "Failed to update Feedback!",
      width: size.width * 0.4,
      backgroundColor: Constants()
          .primaryAppColor
          .withOpacity(0.8));
      feedBackController.clear();
      Navigator.pop(context);
    });



  //   Response response = await MessagesFireCrud.addMessage(
  //     content: descriptionController.text,
  //     userId: user.email!,
  //   );
  //
  //   if (response.code == 200) {
  //     await CoolAlert.show(
  //         context: context,
  //         type: CoolAlertType.success,
  //         text: "Request Sended successfully!",
  //         width: size.width * 0.4,
  //         backgroundColor: Constants()
  //             .primaryAppColor
  //             .withOpacity(0.8));
  //     setState(() {
  //       descriptionController.text = "";
  //     });
  //   }  Navigator.pop(context);
  // } else {
  // await CoolAlert.show(
  // context: context,
  // type: CoolAlertType.error,
  // text: "Failed to send Request!",
  // width: size.width * 0.4,
  // backgroundColor: Constants()
  //     .primaryAppColor
  //     .withOpacity(0.8));
  // Navigator.pop(context);
  // }


  }


}

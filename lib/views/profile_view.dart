import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';
import '../services/user_firecrud.dart';
import 'about_church_view.dart';
import 'intro_view.dart';
import 'languages_view.dart';
import 'notifications_view.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {

  TextEditingController descriptionController = TextEditingController();

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour > 17) {
      return "Good Evening,";
    } else if (hour > 12) {
      return "Good Afternoon,";
    } else {
      return "Good Morning,";
    }
  }

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Profile",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users')
            .snapshots()
            .map((snapshot) => snapshot.docs
            .where((element) => element['id'] == widget.uid)
            .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
            .toList().first),
        builder: (ctx,snaps){
          if(snaps.hasData){
            UserModel user = snaps.data!;
            return Container(
              color: const Color(0xffF9F9F9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.18,
                    width: size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          height: size.height * 0.18,
                          width: size.width*0.3,
                          child: Lottie.asset(
                            'assets/profileanim.json',fit: BoxFit.contain,
                            height: 200,
                            width: 200
                          ),
                        ),
                        Container(
                          height: size.height * 0.18,
                          width: size.width *0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.person,color: Constants().primaryAppColor,),
                                      const SizedBox(width: 10),
                                      KText(
                                        text:
                                        "${user.firstName!} ${user.lastName!}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'SM')),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone,color: Constants().primaryAppColor,),
                                      const SizedBox(width: 5),
                                      KText(
                                        text: user.phone!,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: KText(
                                            text: user.email!,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: size.height* 0.06,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                            color: Constants().primaryAppColor,
                            borderRadius:  BorderRadius.circular(10.0)
                        ) ,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            text: "Personal",
                          ),
                          Tab(
                            text: "Family",
                          ),
                          Tab(
                            text: "My Speech",
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              const SizedBox(height: 10),
                              Card(
                                color: Colors.white,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.phone,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              KText(
                                                text: "Phone :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              const SizedBox(width: 5),
                                              KText(
                                                text: user.phone!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              KText(
                                                text: "Email :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              const SizedBox(width: 5),
                                              KText(
                                                text: user.email!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Card(
                                color: Colors.white,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.notes,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              KText(
                                                text: "Marital Status : ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              const SizedBox(width: 5),
                                              KText(
                                                text: user.maritialStatus!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: user.maritialStatus == "Married",
                                          child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(Icons.event,color: Constants().primaryAppColor,),
                                                const SizedBox(width: 10),
                                                KText(
                                                  text: "Anniversary date : ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                                const SizedBox(width: 5),
                                                KText(
                                                  text: user.anniversaryDate!,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_pin,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              KText(
                                                text: "Locality :",
                                                style: TextStyle(

                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              const SizedBox(width: 5),
                                              KText(
                                                text: user.locality!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Card(
                                color: Colors.white,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.cases_sharp,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                child: KText(
                                                  text: "Profession : ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              SizedBox(
                                                width: size.width * 0.5,
                                                child: KText(
                                                  text: user.profession!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_city,color: Constants().primaryAppColor,),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                child: KText(
                                                  text: "Address :",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              SizedBox(
                                                width: size.width * 0.5,
                                                child: KText(
                                                  text: user.address!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Families').snapshots(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                var data;
                                snapshot.data!.docs.forEach((element) { 
                                  if(element.get("contactNumber") == user.phone){
                                    data = element;
                                  }
                                });
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const SizedBox(height: 10),
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.text_fields,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Family ID :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['familyId'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.family_restroom,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Family Name :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['name'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.person,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Leader Name : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['leaderName'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.phone,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Contact Number : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['contactNumber'],
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Email :",
                                                        style: TextStyle(

                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['email'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.supervisor_account,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Family Member Count : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['quantity'].toString(),
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.home,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Address : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['address'].toString(),
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.location_city,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "City : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['city'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.local_post_office_outlined,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Pincode : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['zone'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Speeches').snapshots(),
                            builder: (ctx, snapshot) {
                              bool noData = true;
                              if (snapshot.hasData) {
                                var data;
                                snapshot.data!.docs.forEach((element) {
                                  if(element.get("phone") == user.phone){
                                    data = element;
                                    noData = false;
                                  }else{
                                    noData = true;
                                  }
                                });
                                return noData ? Container() : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const SizedBox(height: 10),
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.date_range,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Date :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['date'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.timelapse,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Time :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      KText(
                                                        text: data['time'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.text_snippet_sharp,color: Constants().primaryAppColor,),
                                                      const SizedBox(width: 10),
                                                      KText(
                                                        text: "Speech :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      SizedBox(
                                                        width: size.width * 0.5,
                                                        child: KText(
                                                          text: data['speech'],
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: Constants()
                                                                  .getFontSize(context, 'S')),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }return Container();
        },
      )
    );
  }

  showEditProfilePopUp(context, UserModel user) async {
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
                          text: "EDIT PROFILE",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
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
                                      controller: descriptionController,
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
                                if (descriptionController.text != "") {
                                  Response response =
                                  await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.email!,
                                  );
                                  if (response.code == 200) {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
                                }
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
                                  descriptionController.text = "";
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

  Future<dynamic> _showContactAdminPopUp(
      BuildContext context, UserModel user) async {
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
                          text: "Contact Admin",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
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
                                  text: "Message",
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
                                      controller: descriptionController,
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
                                if (descriptionController.text != "") {
                                  Response response =
                                  await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.email!,
                                  );
                                  if (response.code == 200) {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
                                }
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
                                  descriptionController.text = "";
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
}

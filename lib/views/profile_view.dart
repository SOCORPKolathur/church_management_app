import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {

  TextEditingController descriptionController = TextEditingController();
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
            .map((doc) => UserModel.fromJson(doc.data()))
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
                        Lottie.asset(
                          'assets/profileanim.json',fit: BoxFit.contain,
                          height: size.height * 0.18,
                          width: size.width * 0.4,
                        ),
                        SizedBox(
                          height: size.height * 0.18,
                          width: size.width *0.6,
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
                                      SizedBox(width: size.width/41.1),
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
                                      SizedBox(width: size.width/82.2),
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
                                        SizedBox(width: size.width/82.2),
                                        SizedBox(
                                          width: size.width * 0.5,
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
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
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
                              SizedBox(height: size.height/86.6),
                              SizedBox(height: size.height/86.6),
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
                                              SizedBox(width: size.width/41.1),
                                              KText(
                                                text: "Phone :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              SizedBox(width: size.width/82.2),
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
                                        SizedBox(height: size.height/86.6),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                              SizedBox(width: size.width/41.1),
                                              KText(
                                                text: "Email :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              SizedBox(width: size.width/82.2),
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
                              SizedBox(height: size.height/86.6),
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
                                        SizedBox(height: size.height/48.111111111),
                                        Visibility(
                                          visible: user.maritialStatus == "Married",
                                          child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(Icons.event,color: Constants().primaryAppColor,),
                                                SizedBox(width: size.width/41.1),
                                                KText(
                                                  text: "Anniversary date : ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                          context, 'S')),
                                                ),
                                                SizedBox(width: size.width/82.2),
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
                                        SizedBox(height: size.height/86.6),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_pin,color: Constants().primaryAppColor,),
                                              SizedBox(width: size.width/41.1),
                                              KText(
                                                text: "Locality :",
                                                style: TextStyle(

                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              ),
                                              SizedBox(width: size.width/82.2),
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
                              SizedBox(height: size.height/86.6),
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
                                              SizedBox(width: size.width/41.1),
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
                                              SizedBox(width: size.width/82.2),
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
                                        SizedBox(height: size.height/86.6),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_city,color: Constants().primaryAppColor,),
                                              SizedBox(width: size.width/41.1),
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
                                              SizedBox(width: size.width/82.2),
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
                              bool noData = true;
                              if (snapshot.hasData) {
                                var data;
                                snapshot.data!.docs.forEach((element) {
                                  if(element.get("contactNumber") == user.phone){
                                    data = element;
                                    noData = false;
                                  }
                                });
                                return noData
                                    ?
                                  Center(
                                    child: Lottie.asset(
                                      'assets/no_data.json',
                                      fit: BoxFit.contain,
                                      height: size.height * 0.4,
                                      width: size.width * 0.7,
                                    ),
                                  )
                                    : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: size.height/86.6),
                                      SizedBox(height: size.height/86.6),
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
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Family ID :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/86.6),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.family_restroom,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Family Name :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                      SizedBox(height: size.height/86.6),
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
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Leader Name : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/86.6),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.phone,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Contact Number : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/86.6),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Email :",
                                                        style: TextStyle(

                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                      SizedBox(height: size.height/86.6),
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
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Family Member Count : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                      SizedBox(height: size.height/86.6),
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.home,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Address : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
                                                      SizedBox(
                                                        width: size.width * 0.6,
                                                        child: KText(
                                                          text: data['address'].toString(),
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: Constants()
                                                                  .getFontSize(context, 'S')),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: size.height/48.111111111),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.location_city,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "City : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/48.111111111),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.local_post_office_outlined,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Pincode : ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Constants()
                                                                .getFontSize(
                                                                context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                      SizedBox(height: size.height/86.6),
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
                                  }
                                });
                                return noData ? Center(
                                  child: Lottie.asset(
                                    'assets/no_data.json',
                                    fit: BoxFit.contain,
                                    height: size.height * 0.4,
                                    width: size.width * 0.7,
                                  ),
                                ) : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: size.height/86.6),
                                      SizedBox(height: size.height/86.6),
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
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Date :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/86.6),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.timelapse,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Time :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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
                                                SizedBox(height: size.height/86.6),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.text_snippet_sharp,color: Constants().primaryAppColor,),
                                                      SizedBox(width: size.width/41.1),
                                                      KText(
                                                        text: "Speech :",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Constants()
                                                                .getFontSize(context, 'S')),
                                                      ),
                                                      SizedBox(width: size.width/82.2),
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


}

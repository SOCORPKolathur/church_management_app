import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView>  with SingleTickerProviderStateMixin {
  String searchString = "";
  TabController? tabController;
  int selectTabIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    searchString = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Community",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Members').snapshots(),
            builder: (ctx, snapMember){
              if(snapMember.hasData){
                List members = [];
                var members1 = snapMember.data!;
                members1.docs.forEach((element) {
                  if(searchString != ""){
                    if(element.get("position")!.toLowerCase().startsWith(searchString.toLowerCase())||
                        element.get("firstName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                        (element.get("firstName")!+element.get("lastName")!).toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                        element.get("lastName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                        element.get("phone")!.toLowerCase().startsWith(searchString.toLowerCase())){
                      members.add(element);
                    }
                  }else{
                    members.add(element);
                  }
                });
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> users = [];
                      var users1 = snapshot.data!;
                      users1.docs.forEach((element) {
                        if(element.get("isPrivacyEnabled") == false){
                          if(searchString != ""){
                            if(element.get("profession")!.toLowerCase().startsWith(searchString.toLowerCase())||
                                element.get("firstName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                                (element.get("firstName")!+element.get("lastName")!).toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                                element.get("lastName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                                element.get("phone")!.toLowerCase().startsWith(searchString.toLowerCase())){
                              users.add(UserModel.fromJson(element.data()));
                            }
                          }else{
                            users.add(UserModel.fromJson(element.data()));
                          }
                        }
                      });
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFCF2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Constants().primaryAppColor, width: 2),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    searchString = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  icon:
                                  SvgPicture.asset("assets/search.svg", height: 23),
                                ),
                              ),
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
                                labelColor: Constants().primaryAppColor,
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: Constants().primaryAppColor,
                                indicatorPadding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                labelPadding: const EdgeInsets.all(0),
                                splashBorderRadius: BorderRadius.zero,
                                splashFactory: NoSplash.splashFactory,
                                labelStyle: GoogleFonts.openSans(
                                  fontSize: size.width / 20,
                                  fontWeight: FontWeight.w800,
                                ),
                                unselectedLabelStyle: GoogleFonts.openSans(
                                  fontSize: size.width / 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                onTap: (index){
                                  setState(() {
                                    selectTabIndex = index;
                                    isLoading = true;
                                  });
                                },
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Users"),
                                        Visibility(
                                            visible: users.isNotEmpty,
                                            child: SizedBox(
                                                width: size.width * 0.01)),
                                        Visibility(
                                          visible: users.isNotEmpty,
                                          child: Badge(
                                            backgroundColor: Constants().primaryAppColor,
                                            label: Text(
                                              users.length.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Members"),
                                        Visibility(
                                            visible: members.isNotEmpty,
                                            child: SizedBox(
                                                width: size.width * 0.01)),
                                        Visibility(
                                          visible: members.isNotEmpty,
                                          child: Badge(
                                            backgroundColor:  Constants().primaryAppColor,
                                            label: Text(
                                              members.length.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                buildUserDataCardList(users),
                                buildMemberDataCardList(members)
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.1),
                        ],
                      );
                    }
                    return Container();
                  },
                );
              }return Container();
            },
          )
        ),
      ),
    );
  }

  buildUserDataCardList(List<UserModel> users){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < users.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Card(
                color: Colors.white,
                child: SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              Text(
                                "${users[i].firstName!} ${users[i].lastName!}",
                                style: GoogleFonts.amaranth(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Constants()
                                      .getFontSize(context, 'M'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_pin_outlined,
                                  color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              KText(
                                text:users[i].profession!,
                                style: GoogleFonts.amaranth(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Constants()
                                        .getFontSize(context, 'S')),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        SizedBox(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.phone, color: Constants().primaryAppColor),
                                  SizedBox(width: size.width/41.1),
                                  InkWell(
                                    onTap: () async {
                                      final Uri launchUri = Uri(
                                        scheme: 'tel',
                                        path:users[i].phone!,
                                      );
                                      await launchUrl(launchUri);
                                    },
                                    child: KText(
                                      text: users[i].phone!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Constants()
                                              .getFontSize(context, 'S')),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () async {
                                  final Uri launchUri = Uri(
                                    path: 'https://api.whatsapp.com/send?phone=${users[i].phone!}&text=Hii%20${users[i].firstName!} ${users[i].lastName!},%20I%20got%20your%20contact%20on%20IKIA',
                                  );
                                  await launchUrl(launchUri);
                                },
                                  child: Icon(Icons.chat,color: Constants().primaryAppColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  buildMemberDataCardList(List members){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < members.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Card(
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              Text(
                                "${members[i]['firstName']!} ${members[i]['lastName']!}",
                                style: GoogleFonts.amaranth(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Constants()
                                      .getFontSize(context, 'M'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_pin_outlined,
                                  color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              KText(
                                text: members[i]['position'],
                                style: GoogleFonts.amaranth(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Constants()
                                        .getFontSize(context, 'S')),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        InkWell(
                          onTap: () async {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: members[i]['phone'],
                            );
                            await launchUrl(launchUri);
                          },
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Constants().primaryAppColor),
                                    SizedBox(width: size.width/41.1),
                                    KText(
                                      text: members[i]['phone'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Constants()
                                              .getFontSize(context, 'S')),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                    onTap: () async {
                                      final Uri launchUri = Uri(
                                        path: 'https://api.whatsapp.com/send?phone=${members[i]['phone']}&text=Hii%20${members[i]['firstName']!} ${members[i]['lastName']!},%20I%20got%20your%20contact%20on%20IKIA',
                                      );
                                      await launchUrl(launchUri);
                                    },
                                    child: Icon(Icons.chat,color: Constants().primaryAppColor)),
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
        ],
      ),
    );
  }

}

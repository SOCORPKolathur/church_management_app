import 'package:animate_do/animate_do.dart';
import 'package:church_management_client/views/products_view.dart';
import 'package:church_management_client/views/profile_view.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/bottom_nav_item_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';
import '../services/user_firecrud.dart';
import 'community_view.dart';
import 'events_view.dart';
import 'headers/community_header.dart';
import 'headers/event_header.dart';
import 'headers/home_header.dart';
import 'headers/product_header.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView(
      {super.key,
      required this.uid,
      required this.userDocId,
      required this.phone});

  final String uid;
  final String userDocId;
  final String phone;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  int pageIndex = 0;
  int previousIndex = 0;
  int changingIndex = 50;
  String directionText = "Left";
  TextEditingController descriptionController = TextEditingController();
  PageController pageController1 = PageController();
  PageController pageController = PageController();
  AnimationController? animationController1, animationController;

  final ValueNotifier<bool> isAnimate1 = ValueNotifier<bool>(false);

  String getDirection(int from, int to) {
    String direction = "";
    if (from < to) {
      direction = "Right";
    } else {
      direction = "Left";
    }
    return direction;
  }

  bool isAnimate = true;
  double animateValue = 1;

  @override
  void initState() {
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<BottomNavItem> bottomNavList = [
      BottomNavItem(
        name: "Home",
        icon: Icons.home,
        header: Container(),
        page: HomeView(uid: widget.uid, userDocId: widget.userDocId,phone: widget.phone),
      ),
      BottomNavItem(
        name: "Connect",
        icon: Icons.message,
        header: const EventHeader(),
        page: EventsView(phone: widget.phone),
      ),
      BottomNavItem(
        name: "Products",
        icon: Icons.shopping_cart_rounded,
        header: ProductHeader(uid: widget.uid, userDocId: widget.userDocId),
        page: ProductsView(uid: widget.uid, userDocId: widget.userDocId),
      ),
      BottomNavItem(
        name: "Community",
        icon: Icons.perm_contact_calendar_outlined,
        header: const CommunityHeader(),
        page: const CommunityView(),
      ),
      BottomNavItem(
        name: "Profile",
        icon: Icons.person,
        header: Container(),
        page: ProfileView(uid: widget.uid, userDocId: widget.userDocId),
      )
    ];
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     opacity: 0.67,
          //     image: AssetImage("assets/cloud2.png"),
          //   ),
          // ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.38,
                    width: size.width,
                    child: Stack(
                      children: [
                        Container(
                          height: size.height,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/cloud1.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xffF9F9F9)
                          // image: DecorationImage(
                          //   fit: BoxFit.fill,
                          //   image: AssetImage("assets/backimg.png"),
                          // ),
                        )),
                  ),
                ],
              ),
              Container(
                height: size.height,
                width: size.width,
                color: Colors.white54,
              ),
              Column(
                children: [
                  // StreamBuilder(
                  //   stream: UserFireCrud.fetchUsersWithId(widget.uid),
                  //   builder: (ctx, snapshot) {
                  //     if (snapshot.hasData) {
                  //       UserModel user = snapshot.data!;
                  //       return SizedBox(
                  //         height: size.height * 0.28,
                  //         width: size.width,
                  //         child: Stack(
                  //           children: [
                  //             SizedBox(
                  //                 height: size.height * 0.28,
                  //                 width: double.infinity,
                  //                 child: (pageIndex == 0 ||
                  //                         pageIndex == 4)
                  //                     ? HomeHeader(
                  //                         user: user,
                  //                         userDocId: widget.userDocId)
                  //                     : bottomNavList[pageIndex]
                  //                         .header!)
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //     return Container();
                  //   },
                  // ),
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: TabBarView(
                      controller: _motionTabBarController,
                      children: bottomNavList.map((e) => e.page!).toList(),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(bottomNavList),
    );
  }

  bottomBar(List<BottomNavItem> list) {
    return MotionTabBar(
      controller: _motionTabBarController,
      // ADD THIS if you need to change your tab programmatically
      initialSelectedTab: "Home",
      useSafeArea: true,
      // default: true, apply safe area wrapper
      labels: [
        list[0].name!,
        list[1].name!,
        list[2].name!,
        list[3].name!,
        list[4].name!
      ],
      icons: [
        list[0].icon!,
        list[1].icon!,
        list[2].icon!,
        list[3].icon!,
        list[4].icon!
      ],
      badges: [],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: TextStyle(
        fontSize: 12,
        color: Constants().primaryAppColor,//Colors.white,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Constants().primaryAppColor,//Colors.white,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: Constants().primaryAppColor,//Colors.white,
      tabIconSelectedColor: Colors.white,//Constants().primaryAppColor,
      tabBarColor: Colors.white,//Constants().primaryAppColor,
      onTabItemSelected: (int value) {
        setState(() {
          _motionTabBarController!.index = value;
        });
      },
    );
  }

  // bottomBar(List<BottomNavItem> list) {
  //   return FFNavigationBar(
  //     theme: FFNavigationBarTheme(
  //       selectedItemTextStyle:
  //           GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold),
  //       unselectedItemTextStyle:
  //           GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold),
  //       barBackgroundColor: Constants().primaryAppColor,
  //       selectedItemBorderColor: Constants().primaryAppColor,
  //       selectedItemBackgroundColor: Colors.white,
  //       selectedItemIconColor: Constants().primaryAppColor,
  //       selectedItemLabelColor: Colors.white,
  //       unselectedItemIconColor: Colors.white,
  //       unselectedItemLabelColor: Colors.white,
  //       showSelectedItemShadow: true,
  //     ),
  //     selectedIndex: pageIndex,
  //     onSelectTab: (index) async {
  //       setState(() {
  //         animateValue = 0;
  //       });
  //       await Future.delayed(const Duration(milliseconds: 200));
  //       setState(() {
  //         pageIndex = index;
  //       });
  //     },
  //     items: list
  //         .map(
  //           (e) => FFNavigationBarItem(
  //             iconData: e.icon!,
  //             label: e.name!,
  //             animationDuration: const Duration(seconds: 1),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

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

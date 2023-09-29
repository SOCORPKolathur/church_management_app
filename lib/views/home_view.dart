import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:church_management_client/models/event_model.dart';
import 'package:church_management_client/services/events_firecrud.dart';
import 'package:church_management_client/views/events_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/blog_model.dart';
import '../models/gallery_image_model.dart';
import '../models/notice_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/blog_firecrud.dart';
import '../services/gallery_firecrud.dart';
import '../services/messages_firecrud.dart';
import '../services/notice_firecrud.dart';
import '../services/user_firecrud.dart';
import 'about_church_view.dart';
import 'blog_details_view.dart';
import 'blogs_list_view.dart';
import 'intro_view.dart';
import 'languages_view.dart';
import 'notices_list_view.dart';
import 'notifications_view.dart';

class HomeView extends StatefulWidget {
  const HomeView(
      {super.key,
      required this.userDocId,
      required this.uid,
      required this.phone});

  final String uid;
  final String phone;
  final String userDocId;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TextEditingController descriptionController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  int sliderImageIndex = 0;
  ScrollController scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        title: Text("IKIA"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal),
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: UserFireCrud.fetchUsersWithId(widget.uid),
                builder: (ctx, snaps) {
                  if (snaps.hasData) {
                    UserModel user = snaps.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height * 0.07,
                              width: size.height * 0.07,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: (user.imgUrl != null)
                                      ? CachedNetworkImageProvider(
                                          user.imgUrl!,
                                        )
                                      : const CachedNetworkImageProvider(
                                          "https://firebasestorage.googleapis.com/v0/b/church-management-cbf7d.appspot.com/o/dailyupdates%2Fblank-profile-picture-973460_1280.png?alt=media&token=a9cde0ad-6cac-49d3-ae62-851a174e44b4"),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => NotificationsView(
                                                userDocId: widget.userDocId)));
                                  },
                                  child: const Icon(
                                    CupertinoIcons.bell_solid,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Languages',
                                      child: const KText(
                                        text: 'Languages',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {},
                                    ),
                                    PopupMenuItem(
                                      value: 'About Church',
                                      child: const KText(
                                        text: 'About Church',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {},
                                    ),
                                    PopupMenuItem(
                                      value: 'Contact Admin',
                                      child: const KText(
                                        text: 'Contact Admin',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {},
                                    ),
                                    PopupMenuItem(
                                      value: 'Edit Profile',
                                      child: const KText(
                                        text: 'Edit Profile',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {},
                                    ),
                                    PopupMenuItem(
                                      value: 'Log out',
                                      child: const KText(
                                        text: 'Log out',
                                        style: TextStyle(),
                                      ),
                                      onTap: () {},
                                    )
                                  ],
                                  position: PopupMenuPosition.over,
                                  offset: const Offset(0, 30),
                                  color: const Color(0xffFFFFFF),
                                  elevation: 2,
                                  onSelected: (val) async {
                                    switch (val) {
                                      case "Languages":
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => LanguagesView(
                                                    phone: user.phone!,
                                                    uid: user.id!,
                                                    userDocId:
                                                        widget.userDocId)));
                                        break;
                                      case "About Church":
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const AboutChurchView()));
                                        break;
                                      case "Contact Admin":
                                        _showContactAdminPopUp(context, user);
                                        break;
                                      case "Edit Profile":
                                        showEditProfilePopUp(context, user);
                                        break;
                                      case "Log out":
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.warning,
                                            text: "Are you sure want to Logout",
                                            onConfirmBtnTap: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          const IntroView()));
                                            },
                                            confirmBtnText: 'Log Out',
                                            cancelBtnText: 'Cancel',
                                            showCancelBtn: true,
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        break;
                                    }
                                  },
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: const Icon(Icons.settings, size: 28),
                                ),
                                const SizedBox(width: 15),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: greeting(),
                              style: GoogleFonts.amaranth(
                                fontSize: Constants().getFontSize(context, "L"),
                                fontWeight: FontWeight.w600,
                              ),
                              // style: TextStyle(
                              //   fontSize: Constants().getFontSize(context, "L"),
                              //   fontFamily: "ArgentumSans",
                              // ),
                            ),
                            Text(
                              "${user.firstName!} ${user.lastName!}",
                              style: GoogleFonts.amaranth(
                                fontSize: Constants().getFontSize(context, "XL"),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: size.height * 0.02),
              // KText(
              //   text: "Church Updates",
              //   style: GoogleFonts.openSans(
              //     fontSize: Constants().getFontSize(context, 'M'),
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              SizedBox(height: size.height * 0.01),
              StreamBuilder(
                stream: GalleryFireCrud.fetchSliderImages(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<GalleryImageModel> sliderImages = snapshot.data!;
                    return Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.22,
                          width: double.infinity,
                          // child: CarouselSlider.builder(
                          //     itemCount: sliderImages.length,
                          //     itemBuilder: ( context,int index, int) {
                          //       return Container(
                          //           width:size.width/1.12,
                          //           height:size.height/8.6,
                          //           child: Container(
                          //               width:size.width/1.12,
                          //               height:size.height/8.92,
                          //               decoration: BoxDecoration(
                          //                   borderRadius: BorderRadius.circular(12)
                          //               ),
                          //               child: CachedNetworkImage(
                          //                   width:size.width/1.12,
                          //                   height:size.height/8.92,
                          //                   fit: BoxFit.contain,
                          //                   imageUrl: sliderImages[index].imgUrl!
                          //               )
                          //           ),
                          //         );
                          //     },
                          //     options: ,
                          // ),
                        ),
                        Center(
                          child: DotsIndicator(
                            dotsCount: sliderImages.length,
                            position: sliderImageIndex,
                            decorator: DotsDecorator(
                              size: const Size.square(8.0),
                              activeSize: const Size(19.0, 8.0),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  KText(
                    text: "Notices by Church",
                    style: GoogleFonts.openSans(
                      fontSize: Constants().getFontSize(context, 'M'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const NoticesListView()));
                    },
                    child: const Icon(
                      Icons.chevron_right_sharp,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.16,
                width: size.width,
                child: StreamBuilder(
                  stream: NoticeFireCrud.fetchNotice(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<NoticeModel> notices = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: notices.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                showNoticesPopUp(context, notices[i]);
                              },
                              child: SizedBox(
                                height: size.height * 0.07,
                                width: size.width * 0.8,
                                child: Card(
                                  color: Colors.white,
                                  // height: size.height * 0.07,
                                  // width: size.width * 0.8,
                                  // margin: const EdgeInsets.all(8.0),
                                  // padding: const EdgeInsets.all(8.0),
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              notices[i].date!,
                                              style: GoogleFonts.openSans(
                                                color: Colors.grey,
                                                fontSize: Constants()
                                                    .getFontSize(context, "S"),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              notices[i].time!,
                                              style: GoogleFonts.openSans(
                                                color: Colors.grey,
                                                fontSize: Constants()
                                                    .getFontSize(context, "S"),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        KText(
                                          text: notices[i].title!,
                                          style: GoogleFonts.openSans(
                                            fontSize: Constants()
                                                .getFontSize(context, 'M'),
                                            color: Constants().primaryAppColor,
                                            //const Color(0xff000850),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: KText(
                                              text: notices[i].description!,
                                              style: GoogleFonts.openSans(
                                                fontSize: Constants()
                                                    .getFontSize(context, 'SM'),
                                                color: const Color(0xff454545),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  KText(
                    text: "Events",
                    style: GoogleFonts.openSans(
                      fontSize: Constants().getFontSize(context, 'M'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  EventsListView(phone: widget.phone)));
                    },
                    child: const Icon(
                      Icons.chevron_right_sharp,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.22,
                width: size.width,
                child: StreamBuilder(
                  stream: EventsFireCrud.fetchEvents(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<EventsModel> events = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: events.length,
                          itemBuilder: (context, j) {
                            return VisibilityDetector(
                              key: const Key('my-widget-key'),
                              onVisibilityChanged:
                                  (VisibilityInfo visibilityInfo) {
                                var visiblePercentage =
                                    visibilityInfo.visibleFraction;
                                if (visiblePercentage == 1.0) {
                                  updateEventViewCount(events[j], widget.phone);
                                }
                              },
                              child: Container(
                                width: size.width * 0.88,
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showImageModel(
                                            context, events[j].imgUrl!);
                                      },
                                      child: Container(
                                        height: size.height * 0.16,
                                        width: size.width * 0.37,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: CachedNetworkImageProvider(
                                              events[j].imgUrl!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.43,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: KText(
                                                text: events[j].title!,
                                                style: GoogleFonts.openSans(
                                                  fontSize: Constants()
                                                      .getFontSize(context, 'M'),
                                                  color: const Color(0xff000850),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: SizedBox(
                                              width: size.width * 0.5,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.date_range,
                                                      color: Constants()
                                                          .primaryAppColor),
                                                  const SizedBox(width: 5),
                                                  KText(
                                                    text: events[j].date!,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S'),
                                                      color:
                                                          const Color(0xff454545),
                                                      fontWeight: FontWeight.w600,
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
                                                  Icon(Icons.timelapse,
                                                      color: Constants()
                                                          .primaryAppColor),
                                                  const SizedBox(width: 5),
                                                  KText(
                                                    text: events[j].time!,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S'),
                                                      color:
                                                          const Color(0xff454545),
                                                      fontWeight: FontWeight.w600,
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
                                                  Icon(Icons.location_pin,
                                                      color: Constants()
                                                          .primaryAppColor),
                                                  const SizedBox(width: 5),
                                                  KText(
                                                    text: events[j].location!,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S'),
                                                      color:
                                                          const Color(0xff454545),
                                                      fontWeight: FontWeight.w600,
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
                                                  Icon(Icons.message_outlined,
                                                      color: Constants()
                                                          .primaryAppColor),
                                                  const SizedBox(width: 5),
                                                  KText(
                                                    text: events[j].description!,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S'),
                                                      color:
                                                          const Color(0xff454545),
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
                            );
                          });
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  KText(
                    text: "Blogs",
                    style: GoogleFonts.openSans(
                      fontSize: Constants().getFontSize(context, 'M'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const BlogsListView()));
                    },
                    child: const Icon(
                      Icons.chevron_right_sharp,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.22,
                width: size.width,
                child: StreamBuilder(
                  stream: BlogFireCrud.fetchBlogs(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<BlogModel> blogs = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: blogs.length,
                          itemBuilder: (context, j) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Card(
                                color: Colors.white,
                                child: Container(
                                  width: size.width * 0.88,
                                  // padding: const EdgeInsets.all(8.0),
                                  // margin: const EdgeInsets.all(1.0),
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showImageModel(context, blogs[j].imgUrl!);
                                        },
                                        child: Container(
                                          height: size.height * 0.16,
                                          width: size.width * 0.37,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: CachedNetworkImageProvider(
                                                blogs[j].imgUrl!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.43,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: KText(
                                                  text: blogs[j].title!,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'M'),
                                                    color: const Color(0xff000850),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.5,
                                                child: KText(
                                                  text: blogs[j].description!,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S'),
                                                    color: const Color(0xff454545),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              BlogDetailsView(
                                                                  id: blogs[j].id!)));
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: size.width * 0.38,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Constants().primaryAppColor,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                      text: "View Blog",
                                                      style: TextStyle(
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S'),
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  showNoticesPopUp(context, NoticeModel notice) async {
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
                          text: notice.title!,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notice.date!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notice.time!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: KText(
                                      text: notice.description!,
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
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

  updateEventViewCount(EventsModel event, String phone) async {
    List<String> views = [];
    event.views!.forEach((element) {
      views.add(element);
    });
    if (!views.contains(phone)) {
      views.add(phone);
    }
    var document = await FirebaseFirestore.instance
        .collection('Events')
        .doc(event.id)
        .update({"views": views});
  }
}

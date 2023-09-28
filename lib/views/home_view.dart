import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/blog_model.dart';
import '../models/gallery_image_model.dart';
import '../models/notice_model.dart';
import '../services/blog_firecrud.dart';
import '../services/gallery_firecrud.dart';
import '../services/notice_firecrud.dart';
import 'blog_details_view.dart';
import 'blogs_list_view.dart';
import 'notices_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  int sliderImageIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KText(
              text: "Church Updates",
              style: GoogleFonts.openSans(
                fontSize: Constants().getFontSize(context, 'M'),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
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
                        child: Swiper(
                          autoplay: true,
                          onIndexChanged: (index) {
                            setState(() {
                              sliderImageIndex = index;
                            });
                          },
                          itemCount: sliderImages.length,
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {
                                showImageModel(
                                    context, sliderImages[i].imgUrl!);
                              },
                              child: Container(
                                height: 184,
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                      sliderImages[i].imgUrl!,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
                            onTap: (){
                              showNoticesPopUp(context, notices[i]);
                            },
                            child: Container(
                              height: size.height * 0.07,
                              width: size.width * 0.8,
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        notices[i].date!,
                                        style: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: Constants().getFontSize(context, "S"),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        notices[i].time!,
                                        style: GoogleFonts.openSans(
                                          color: Colors.grey,
                                          fontSize: Constants().getFontSize(context, "S"),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  KText(
                                    text: notices[i].title!,
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          Constants().getFontSize(context, 'M'),
                                      color: const Color(0xff000850),
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
                          return Container(
                            width: size.width * 0.88,
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                        height:30,
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
                            setState(() {

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
                                    fontSize: Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notice.time!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: Constants().getFontSize(context, "S"),
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
                                        fontSize:
                                        Constants().getFontSize(context, 'S'),
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
}

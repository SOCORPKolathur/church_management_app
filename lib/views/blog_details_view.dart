import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/blog_model.dart';
import '../services/blog_firecrud.dart';

class BlogDetailsView extends StatefulWidget {
  const BlogDetailsView({super.key, required this.id, required this.phone});

  final String id;
  final String phone;

  @override
  State<BlogDetailsView> createState() => _BlogDetailsViewState();
}

class _BlogDetailsViewState extends State<BlogDetailsView> {

  updateLike(BlogModel blog, String phone) async {
    List<String> likes = [];
    blog.likes!.forEach((element) {
      likes.add(element);
    });
    if (!likes.contains(phone)) {
      likes.add(phone);
    }else{
      likes.remove(phone);
    }
    var document = await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(blog.id)
        .update({"likes": likes});
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      body: SafeArea(
        child: StreamBuilder(
          stream: BlogFireCrud.fetchBlogWithId(widget.id),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              BlogModel blog = snapshot.data!;
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      showImageModel(context, blog.imgUrl!);
                    },
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                            blog.imgUrl!,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              elevation: 2,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              updateLike(blog,widget.phone);
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              elevation: 2,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                    blog.likes!.contains(widget.phone) ? Icons.favorite : Icons.favorite_border
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: blog.title!,
                              style: GoogleFonts.openSans(
                                fontSize: Constants().getFontSize(context, 'M'),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                KText(
                                  text: "Author : ",
                                  style: GoogleFonts.openSans(
                                    fontSize: Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.01),
                                Text(
                                  blog.author!,
                                  style: GoogleFonts.openSans(
                                    color: Constants().primaryAppColor,
                                    fontSize: Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height/86.6),
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(top: size.height/43.3, left: size.width/20.55, right: size.width/20.55),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    KText(
                                      text: blog.description!,
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
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

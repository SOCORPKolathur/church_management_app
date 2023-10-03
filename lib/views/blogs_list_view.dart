import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/blog_model.dart';
import '../services/blog_firecrud.dart';
import 'blog_details_view.dart';

class BlogsListView extends StatefulWidget {
  const BlogsListView({super.key});

  @override
  State<BlogsListView> createState() => _BlogsListViewState();
}

class _BlogsListViewState extends State<BlogsListView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "Blogs",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, 'L'),
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
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: BlogFireCrud.fetchBlogs(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<BlogModel> blogs = snapshot.data!;
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    width: size.width,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                            showImageModel(context, blogs[i].imgUrl!);
                          },
                          child: Container(
                            height: size.height * 0.18,
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                  blogs[i].imgUrl!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: blogs[i].title!,
                                style: GoogleFonts.openSans(
                                  fontSize: Constants().getFontSize(context, 'M'),
                                  color: const Color(0xff000850),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height/173.2),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.5,
                                  child: KText(
                                    text: blogs[i].description!,
                                    style: GoogleFonts.openSans(
                                      fontSize: Constants().getFontSize(context, 'S'),
                                      color: const Color(0xff454545),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height/173.2),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                BlogDetailsView(id: blogs[i].id!)));
                                  },
                                  child: Container(
                                    height: size.height/21.65,
                                    width: size.width * 0.38,
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: KText(
                                        text: "View",
                                        style: TextStyle(
                                            fontSize: Constants().getFontSize(context, 'S'),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
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
                },
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

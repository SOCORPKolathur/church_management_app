import 'package:church_management_client/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/video_gallery_model.dart';

class VideoCeremoniesView extends StatefulWidget {
  const VideoCeremoniesView({super.key,required this.scrollController});

  final ScrollController scrollController;

  @override
  State<VideoCeremoniesView> createState() => _VideoCeremoniesViewState();
}

class _VideoCeremoniesViewState extends State<VideoCeremoniesView> {

  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("VideoGallery").snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<GalleryVideoModel> videos = [];
              for(int v = 0; v < snapshot.data!.docs.length; v++){
                videos.add(
                    GalleryVideoModel.fromJson(snapshot.data!.docs[v].data())
                );
              }
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: videos.length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: (){
                      _controller = VideoPlayerController.networkUrl(Uri.parse( videos[i].videoUrl!))
                        ..initialize().then((_) {
                          _controller.play();
                          showVideoModel(context);
                        });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        height: 150,
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
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                videos[i].thumbUrl!,
                            ),
                          ),
                        ),
                        // child: Center(
                        //   child: Icon(Icons.video_library_outlined,size: 60,color: Colors.grey,),
                        // ),
                      ),
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


  showVideoModel(context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height/217,
                      horizontal: width/455.33
                  ),
                  child: Container(
                    height: size.height * 0.8,
                    width: size.width,
                    decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                      color: Constants().primaryAppColor,
                    ),
                    child: _controller.value.isInitialized
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(
                            _controller,
                            ),
                          ),
                        ) : Container(),
                  )
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

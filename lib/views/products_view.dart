import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/views/notifications_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/product_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';
import 'carts_view.dart';
import 'orders_view.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: size.height / 12.5,
        flexibleSpace: Container(
          height: size.height / 9.09,
          width: size.width / 3.92,
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants().primaryAppColor,
                Constants().primaryAppColor,
              ],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Products",
                  style: GoogleFonts.amaranth(
                    color: Colors.white,
                  fontSize: Constants().getFontSize(context, "XL"),
                  fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       KText(
                    //         text: "Products",
                    //         style: GoogleFonts.amaranth(
                    //           fontSize: Constants().getFontSize(context, "XL"),
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    StreamBuilder(
                      stream: UserFireCrud.fetchUsersWithId(widget.uid),
                      builder: (ctx, snapshot){
                        if(snapshot.hasData){
                          UserModel user = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrdersView(userDocId: widget.userDocId)));
                                },
                                child: Container(
                                  height: size.height * 0.06,
                                  width: size.width * 0.45,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFFFCF2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Constants().primaryAppColor, width: 2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag_outlined, color: Constants().primaryAppColor),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: "Your Orders",
                                        style: GoogleFonts.openSans(
                                          color: Constants().primaryAppColor,
                                          fontSize: Constants().getFontSize(context, "S"),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => CartView(userDocId: widget.userDocId, user: user)));
                                },
                                child: Container(
                                  height: size.height * 0.06,
                                  width: size.width * 0.45,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.shopping_cart_outlined,color: Colors.white),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: "Cart",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: Constants().getFontSize(context, "M"),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }return Container();
                      },
                    )
                  ],
                ),
                SizedBox(height: size.height* 0.02,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> products = snapshot.data!.docs.map((e) => ProductModel.fromJson(e.data())).toList();
                      return Column(
                        children: [
                          for (int i = 0; i < products.length; i++)
                            Container(
                              width: size.width,
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
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: size.height * 0.22,
                                    width: size.width * 0.55,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        KText(
                                          maxLines: null,
                                          text: products[i].title!,
                                          style: GoogleFonts.urbanist(
                                            color: const Color(0xff5F5F5F),
                                            fontWeight: FontWeight.w700,
                                            fontSize: Constants().getFontSize(context, "ML"),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          r"$ " + products[i].price!.toString(),
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                Constants().getFontSize(context, "SM"),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                           Response response = await UserFireCrud.addToCart(userDocId: widget.userDocId, price: products[i].price!, imgUrl: products[i].imgUrl!, quantity: 1, productId: products[i].productId!, productName: products[i].title!);
                                           if(response.code == 200){

                                           }else{

                                           }
                                           },
                                          child: Container(
                                            height: size.height * 0.05,
                                            width: size.width * 0.46,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Constants().primaryAppColor,
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.white,
                                                    size: size.height * 0.035,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  KText(
                                                    text: "Add",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: Constants().getFontSize(context, "S"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      showImageModel(context, products[i].imgUrl!);
                                    },
                                    child: Container(
                                      height: size.height * 0.2,
                                      width: size.width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: CachedNetworkImageProvider(
                                          products[i].imgUrl!,
                                        ),
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
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

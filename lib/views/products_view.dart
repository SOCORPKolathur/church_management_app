import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/views/notifications_view.dart';
import 'package:church_management_client/views/product_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/cart_model.dart';
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


  bool isAltredyInCart(List<CartModel> carts, String itemId){
    bool isAltreadyIn = false;
    carts.forEach((element) {
      if(element.productId == itemId){
        isAltreadyIn = true;
      }else{
        isAltreadyIn = false;
      }
    });
    return isAltreadyIn;
  }

  getQuantity(List<CartModel> carts, String itemId){
    print(itemId);
    int quantity = 0;
    carts.forEach((element) {
      if(element.productId == itemId){
        quantity = element.quantity!;
      }
    });
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Products",
              style: GoogleFonts.amaranth(
                color: Colors.white,
              fontSize: Constants().getFontSize(context, "XL"),
              fontWeight: FontWeight.w600,
              ),
            ),
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height/86.6),
                    StreamBuilder(
                      stream: UserFireCrud.fetchUsersWithId(widget.uid),
                      builder: (ctx, snapshot){
                        if(snapshot.hasData){
                          UserModel user = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrdersView(userDocId: widget.userDocId)));
                                },
                                child: Container(
                                  height: size.height * 0.06,
                                  width: size.width * 0.43,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFFFCF2),
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: Constants().primaryAppColor, width: 2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag_outlined, color: Constants().primaryAppColor),
                                      SizedBox(width: size.width/41.1),
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
                                  width: size.width * 0.43,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.shopping_cart_outlined,color: Colors.white),
                                      SizedBox(width: size.width/41.1),
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
                SizedBox(height: size.height* 0.02),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> products = snapshot.data!.docs.map((e) => ProductModel.fromJson(e.data())).toList();
                      return Column(
                        children: [
                          for (int i = 0; i < products.length; i++)
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=> ProductDetailsView(productId: products[i].productId!,productName: products[i].title!,userDocId: widget.userDocId)));
                              },
                              child: Container(
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
                                      height: size.height * 0.16,
                                      width: size.width * 0.55,
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height:size.height/25.3,
                                            width: size.width * 0.45,
                                            child: KText(
                                              maxLines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                              text: products[i].title!,
                                              style: GoogleFonts.urbanist(
                                                color: const Color(0xff5F5F5F),
                                                fontWeight: FontWeight.w700,
                                                fontSize: Constants().getFontSize(context, "M"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height/173.2),
                                          Text(
                                            "₹${products[i].price!}",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Constants().getFontSize(context, "SM"),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                             Response response = await UserFireCrud.addToCart(userDocId: widget.userDocId, price: products[i].price!, imgUrl: products[i].imgUrl!, quantity: 1, productId: products[i].title!+ " 001", productName: products[i].title!);
                                             },
                                            child: StreamBuilder(
                                              stream: UserFireCrud.fetchCartsForUser(widget.userDocId),
                                              builder: (ctx,snap){
                                                if(snap.hasData){
                                                  List<CartModel> carts = snap.data!;
                                                  return Container(
                                                    height: size.height * 0.05,
                                                    width: size.width * 0.46,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Constants().primaryAppColor,
                                                    ),
                                                    child: Center(
                                                      child: isAltredyInCart(carts,products[i].productId!)
                                                          ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              int qty = getQuantity(carts,products[i].productId!)-1;
                                                              if(qty == 0){
                                                                UserFireCrud.deleteCart(userDocId: widget.userDocId, docId: carts[i].id!);
                                                              }else{
                                                                UserFireCrud.updateCartQuantity(userDocId: widget.userDocId, docId: carts[i].id!,quantity: qty);
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.remove_circle_outline,
                                                              color: Colors.white,
                                                              size: size.height * 0.035,
                                                            ),
                                                          ),
                                                          SizedBox(width: size.width/41.1),
                                                          KText(
                                                            text: getQuantity(carts,products[i].productId!).toString(),
                                                            style: GoogleFonts.openSans(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: Constants().getFontSize(context, "S"),
                                                            ),
                                                          ),
                                                          SizedBox(width: size.width/41.1),
                                                          InkWell(
                                                            onTap:(){
                                                              int qty = getQuantity(carts,products[i].productId!)+1;
                                                              UserFireCrud.updateCartQuantity(userDocId: widget.userDocId, docId: carts[i].id!,quantity: qty);
                                                            },
                                                            child: Icon(
                                                              Icons.add_circle_outline,
                                                              color: Colors.white,
                                                              size: size.height * 0.035,
                                                            ),
                                                          ),
                                                        ],
                                                      ) 
                                                          : InkWell(
                                                        onTap: () async {
                                                          Response response = await UserFireCrud.addToCart(userDocId: widget.userDocId, price: products[i].price!, imgUrl: products[i].imgUrl!, quantity: 1, productId: products[i].productId!, productName: products[i].title!);
                                                        },
                                                            child: Center(
                                                        child: KText(
                                                            text: "Add",
                                                            style: GoogleFonts.openSans(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: Constants().getFontSize(context, "S"),
                                                            ),
                                                        ),
                                                      ),
                                                          ),
                                                    ),
                                                  );
                                                }return Container();
                                              },
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: size.height * 0.16,
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
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(height: size.height/86.6),
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


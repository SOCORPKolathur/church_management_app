import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/constants.dart';
import 'package:church_management_client/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/kText.dart';
import '../models/cart_model.dart';
import '../models/response.dart';
import '../services/user_firecrud.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId,required this.productName,required this.userDocId});

  final String productId;
  final String productName;
  final String userDocId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {

  ProductModel currentProduct = ProductModel();
  List<String> categories = [];

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Products').doc(widget.productId).get(),
        builder: (ctx, snap){
          if(snap.hasData){
            currentProduct = ProductModel.fromJson(snap.data!.data() as Map<String,dynamic>);
            categories.clear();
            categories.addAll(currentProduct.categories!.split(','));
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.height/3.036,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(
                          currentProduct.imgUrl!
                        )
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentProduct.title!,
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize:
                                Constants().getFontSize(context, "L"),
                              ),
                            ),
                            Text(
                              "₹${currentProduct.price!}",
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize:
                                Constants().getFontSize(context, "L"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height/37.95),
                        Text(
                          'Description',
                          style: GoogleFonts.urbanist(
                            color: Constants().primaryAppColor,
                            fontWeight: FontWeight.w700,
                            fontSize:
                            Constants().getFontSize(context, "M"),
                          ),
                        ),
                        SizedBox(height: size.height/75.9),
                        Text(
                          currentProduct.description!,
                          style: GoogleFonts.urbanist(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize:
                            Constants().getFontSize(context, "S"),
                          ),
                        ),
                        SizedBox(height: size.height/75.9),
                        Text(
                          'Categories',
                          style: GoogleFonts.urbanist(
                            color: Constants().primaryAppColor,
                            fontWeight: FontWeight.w700,
                            fontSize:
                            Constants().getFontSize(context, "M"),
                          ),
                        ),
                        SizedBox(height: size.height/75.9),
                        SizedBox(
                          height: size.height/18.975,
                          width: size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (ctx,i){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: size.height/18.975,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                                      child: Text(
                                        categories[i],
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                          Constants().getFontSize(context, "M"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                        Text(
                          'Related Products',
                          style: GoogleFonts.urbanist(
                            color: Constants().primaryAppColor,
                            fontWeight: FontWeight.w700,
                            fontSize:
                            Constants().getFontSize(context, "M"),
                          ),
                        ),
                        SizedBox(height: size.height/75.9),
                        SizedBox(
                          height: size.height/3.608333333,
                          width: size.width,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                List<ProductModel> products = snapshot.data!.docs.map((e) => ProductModel.fromJson(e.data())).toList();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder: (ctx,i){
                                    return InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=> ProductDetailsView(productId: products[i].productId!,productName: products[i].title!,userDocId: widget.userDocId)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Container(
                                          width: size.width/2.305882352941176,
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
                                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: size.height/5.421428571428571,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fitHeight,
                                                    image: CachedNetworkImageProvider(
                                                      products[i].imgUrl!,
                                                    ),
                                                  ),
                                                ),
                                                width: double.infinity,
                                              ),
                                              SizedBox(height: size.height/90),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: size.height/28.866666667,
                                                    child: KText(
                                                      maxLines: 1,
                                                      textOverflow: TextOverflow.ellipsis,
                                                      text: products[i].title!,
                                                      style: GoogleFonts.urbanist(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: Constants().getFontSize(context, "M"),
                                                      ),
                                                    ),
                                                  ),
                                                  KText(
                                                    maxLines: null,
                                                    text: "₹${products[i].price!}",
                                                    style: GoogleFonts.urbanist(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: Constants().getFontSize(context, "S"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                        SizedBox(height: size.height/75.9),
                      ],
                    ),
                  )
                ],
              ),
            );
          }return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Products').doc(widget.productId).get(),
        builder: (ctx, snaps){
          if(snaps.hasData){
            ProductModel product = ProductModel.fromJson(snaps.data!.data() as Map<String,dynamic>);
            return SizedBox(
              height: size.height / 11,
              width: size.width,
              child: SizedBox(
                height: size.height / 18,
                child: Center(
                    child: InkWell(
                        onTap: () async {
                          Response response = await UserFireCrud.addToCart(userDocId: widget.userDocId, price: product.price!, imgUrl: product.imgUrl!, quantity: 1, productId: product.productId!, productName: product.title!);
                        },
                        child: StreamBuilder(
                          stream: UserFireCrud.fetchCartsForUser(widget.userDocId),
                          builder: (ctx,snap){
                            if(snap.hasData){
                              List<CartModel> carts = snap.data!;
                              CartModel cart = CartModel();
                              carts.forEach((element) {
                                if(element.productId == widget.productId){
                                  cart = element;
                                }
                              });
                              return Container(
                                height: size.height * 0.06,
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Constants().primaryAppColor,
                                ),
                                child: Center(
                                  child: isAltredyInCart(carts,widget.productId)
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          int qty = getQuantity(carts,widget.productId)-1;
                                          if(qty == 0){
                                            UserFireCrud.deleteCart(userDocId: widget.userDocId, docId: cart.id!);
                                          }else{
                                            UserFireCrud.updateCartQuantity(userDocId: widget.userDocId, docId: cart.id!,quantity: qty);
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.white,
                                          size: size.height * 0.045,
                                        ),
                                      ),
                                      SizedBox(width: size.width/31.1),
                                      KText(
                                        text: getQuantity(carts,widget.productId).toString(),
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Constants().getFontSize(context, "M"),
                                        ),
                                      ),
                                      SizedBox(width: size.width/31.1),
                                      InkWell(
                                        onTap:(){
                                          int qty = getQuantity(carts,widget.productId)+1;
                                          UserFireCrud.updateCartQuantity(userDocId: widget.userDocId, docId: cart.id!,quantity: qty);
                                        },
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.white,
                                          size: size.height * 0.045,
                                        ),
                                      ),
                                    ],
                                  )
                                      : InkWell(
                                    onTap: () async {
                                      Response response = await UserFireCrud.addToCart(userDocId: widget.userDocId, price: product.price!, imgUrl: product.imgUrl!, quantity: 1, productId: product.productId!, productName: product.title!);
                                    },
                                    child: Center(
                                      child: KText(
                                        text: "Add Cart",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Constants().getFontSize(context, "M"),
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
                ),
              ),

            );
          }return Container();
        },
      )
    );
  }
}

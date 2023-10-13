import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/models/orders_model.dart';
import 'package:church_management_client/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key, required this.orderId,required this.userDocId,required this.order});

  final String orderId;
  final String userDocId;
  final OrdersModel order;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {

  Future<List<ProductModel>> getProductsOfOrder() async {
    List<ProductModel> products = [];
    var productDocument = await FirebaseFirestore.instance.collection('Products').get();
    for (var element in widget.order.products!) {
      productDocument.docs.forEach((product) {
        if(element.id == product.get("productId")){
          products.add(ProductModel.fromJson(product.data()));
        }
      });
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: false,
        title: KText(
          text: "Order ID : ${widget.orderId}",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "S"),
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
      body: FutureBuilder(
        future: getProductsOfOrder(),
        builder: (ctx,snap){
          if(snap.hasData){
            List<ProductModel> products = snap.data!;
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
                          height: size.height * 0.2,
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
                              SizedBox(height: size.height/173.2),
                              Row(
                                children: [
                                  Text(
                                    "Amount : ",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Constants()
                                          .getFontSize(context, "SM"),
                                    ),
                                  ),
                                  Text(
                                    "₹${widget.order.products![i].price}",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      Constants().getFontSize(context, "SM"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height/173.2),
                              Row(
                                children: [
                                  Text(
                                    "Qty : ",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Constants()
                                          .getFontSize(context, "SM"),
                                    ),
                                  ),
                                  Text(
                                    "${widget.order.products![i].quantity!}",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      Constants().getFontSize(context, "SM"),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total : ",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Constants()
                                          .getFontSize(context, "SM"),
                                    ),
                                  ),
                                  Text(
                                    "₹${widget.order.products![i].quantity! * widget.order.products![i].price!}",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      Constants().getFontSize(context, "SM"),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            showImageModel(context, products[i].imgUrl!);
                          },
                          child: Container(
                            height: size.height * 0.17,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.contain,
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
          } return Container();
        }
      )
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/cart_model.dart';
import '../models/orders_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, required this.userDocId, required this.user});

  final String userDocId;
  final UserModel user;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  double getTotalAmount(List<CartModel> products) {
    double amount = 0.0;
    for (int i = 0; i < products.length; i++) {
      amount += products[i].price! * products[i].quantity!;
    }
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "Carts",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
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
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: StreamBuilder(
            stream: UserFireCrud.fetchCartsForUser(widget.userDocId),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<CartModel> carts = snapshot.data!;
                return carts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/undraw_empty_cart_co35.svg",
                              height: size.height * 0.246,
                              width: size.width * 0.3,
                            ),
                            SizedBox(height: size.height/43.3),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: size.height/19.244444444,
                                width: size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: Constants().primaryAppColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child:  KText(
                                    text: "Start Shopping",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                for (int i = 0; i < carts.length; i++)
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
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: size.height * 0.18,
                                          width: size.width * 0.55,
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.065,
                                                width: size.width * 0.55,
                                                child: KText(
                                                  maxLines: null,
                                                  text: carts[i].productName!,
                                                  style: GoogleFonts.urbanist(
                                                    color:
                                                        const Color(0xff5F5F5F),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Constants()
                                                        .getFontSize(
                                                            context, "M"),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: size.height/173.2),
                                              Text(
                                                r"$ " +
                                                    carts[i].price!.toString(),
                                                style: GoogleFonts.urbanist(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Constants()
                                                      .getFontSize(
                                                          context, "SM"),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Response res = await UserFireCrud.deleteCart(userDocId: widget.userDocId, docId: carts[i].id!);
                                                },
                                                child: Container(
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.46,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: Constants()
                                                        .primaryAppColor,
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                      text: "Remove",
                                                      style: GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, "S"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: size.height * 0.16,
                                          width: size.width * 0.3,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: CachedNetworkImageProvider(
                                              carts[i].imgUrl!,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          bottomBar(size, carts)
                        ],
                      );
              }
              return Container();
            },
          )),
    );
  }

  bottomBar(Size size, List<CartModel> carts) {
    return Material(
      elevation: 3,
      child: Container(
        height: size.height * 0.071,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(-1, -3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                KText(
                  text: "Total Price : ",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xff5F5F5F),
                    fontWeight: FontWeight.w700,
                    fontSize: Constants().getFontSize(context, "M"),
                  ),
                ),
                SizedBox(width: size.width/51.375),
                SizedBox(
                  width: size.width * 0.35,
                  child: KText(
                    text: getTotalAmount(carts).toString(),
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: Constants().getFontSize(context, "L"),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  List<Products> tempProducts = [];
                  carts.forEach((element) {
                    tempProducts.add(Products(
                        quantity: element.quantity,
                        imgUrl: element.imgUrl,
                        price: element.price,
                        name: element.productName,
                        id: element.id));
                  });
                  Response response = await UserFireCrud.addToOrder(
                    userDocId: widget.userDocId,
                    phone: widget.user.phone!,
                    method: "method",
                    status: "Ordered",
                    userName: widget.user.firstName! + widget.user.firstName!,
                    amount: getTotalAmount(carts),
                    products: tempProducts,
                    address: widget.user.address!,
                  );
                  if (response.code == 200) {
                    for (int k = 0; k < carts.length; k++) {
                      Response res = await UserFireCrud.deleteCart(
                          userDocId: widget.userDocId, docId: carts[k].id!);
                    }
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Ordered successfully!",
                        width: size.width * 0.4,
                        backgroundColor:
                            Constants().primaryAppColor.withOpacity(0.8));
                  } else {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Failed to Order",
                        width: size.width * 0.4,
                        backgroundColor:
                            Constants().primaryAppColor.withOpacity(0.8));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(1),
                  height: size.height * 0.059,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: KText(
                      text: "Checkout",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: Constants().getFontSize(context, "M"),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

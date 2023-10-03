import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/orders_model.dart';
import '../services/user_firecrud.dart';
import 'order_details_view.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key, required this.userDocId});
  final String userDocId;


  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        centerTitle: true,
        title: KText(
          text: "Orders",
          style: GoogleFonts.openSans(
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
          stream: UserFireCrud.fetchOrdersForUser(widget.userDocId),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<OrdersModel> orders = snapshot.data!;
              return orders.isEmpty ? Center(
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
              ) : SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < orders.length; i++)
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> OrderDetailsView(orderId: orders[i].orderId!)));
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
                                    KText(
                                      maxLines: null,
                                      text: orders[i].orderId!,
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xff5F5F5F),
                                        fontWeight: FontWeight.w700,
                                        fontSize: Constants()
                                            .getFontSize(context, "S"),
                                      ),
                                    ),
                                    Text(
                                      orders[i].date!.toString(),
                                      style: GoogleFonts.urbanist(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Constants()
                                            .getFontSize(context, "SM"),
                                      ),
                                    ),
                                    Text(
                                      r"$ " + orders[i].amount!.toString(),
                                      style: GoogleFonts.urbanist(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Constants()
                                            .getFontSize(context, "SM"),
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
                                        orders[i].products!.first.imgUrl!,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

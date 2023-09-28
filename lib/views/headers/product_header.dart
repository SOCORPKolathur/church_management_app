import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/kText.dart';
import '../../constants.dart';
import '../../models/cart_model.dart';
import '../../models/orders_model.dart';
import '../../models/user_model.dart';
import '../../services/user_firecrud.dart';
import '../carts_view.dart';
import '../orders_view.dart';

class ProductHeader extends StatefulWidget {
  const ProductHeader({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProductHeader> createState() => _ProductHeaderState();
}

class _ProductHeaderState extends State<ProductHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height * 0.08,
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: "Products",
                style: GoogleFonts.amaranth(
                  fontSize: Constants().getFontSize(context, "XL"),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
    );
  }
}

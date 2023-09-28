import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/product_model.dart';
import '../models/response.dart';
import '../services/products_firecrud.dart';
import '../services/user_firecrud.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: StreamBuilder(
          stream: ProductsFireCrud.fetchProducts(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!;
              print(products.toString());
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

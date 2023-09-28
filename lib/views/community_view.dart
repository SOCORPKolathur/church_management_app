import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  String searchString = "";

  @override
  void dispose() {
    searchString = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        child: StreamBuilder(
          stream: searchString != ""
              ? UserFireCrud.fetchUsersWithSearchText(
                  searchString.toLowerCase())
              : UserFireCrud.fetchUsers(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<UserModel> users = snapshot.data!;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFCF2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Constants().primaryAppColor, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            searchString = val;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          icon:
                              SvgPicture.asset("assets/search.svg", height: 23),
                        ),
                      ),
                    ),
                  ),
                  for (int i = 0; i < users.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 6),
                      child: Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_outline,
                                          color: Constants().primaryAppColor),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${users[i].firstName!} ${users[i].lastName!}",
                                        style: GoogleFonts.amaranth(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Constants()
                                              .getFontSize(context, 'M'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_pin_outlined,
                                          color: Constants().primaryAppColor),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: users[i].profession!,
                                        style: GoogleFonts.amaranth(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: users[i].phone!,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.phone,
                                            color: Constants().primaryAppColor),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: users[i].phone!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key, required this.uid});

  final String uid;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KText(
              text: "Profile",
              style: GoogleFonts.openSans(
                fontSize: Constants().getFontSize(context, 'M'),
                fontWeight: FontWeight.w600,
              ),
            ),
            StreamBuilder(
              stream: UserFireCrud.fetchUsersWithId(widget.uid),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data!;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 10),
                                      KText(
                                        text:
                                        "${user.firstName!} ${user.lastName!}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.cake),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: user.dob!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.notes),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: size.width * 0.7,
                                          child: KText(
                                            text: user.about!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
                                          ),
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
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: user.phone!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.alternate_email),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: user.email!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.notes),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: user.maritialStatus!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Visibility(
                                  visible: user.maritialStatus == "Married",
                                  child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        const Icon(Icons.event),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: user.anniversaryDate!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(
                                                  context, 'S')),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_pin),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: user.locality!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Constants()
                                                .getFontSize(context, 'S')),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.cases_sharp),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: size.width * 0.7,
                                        child: KText(
                                          text: user.profession!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(
                                                  context, 'S')),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_city),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: size.width * 0.7,
                                        child: KText(
                                          text: user.address!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(
                                                  context, 'S')),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

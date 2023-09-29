import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';
import '../services/user_firecrud.dart';
import 'about_church_view.dart';
import 'intro_view.dart';
import 'languages_view.dart';
import 'notifications_view.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  TextEditingController descriptionController = TextEditingController();

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour > 17) {
      return "Good Evening,";
    } else if (hour > 12) {
      return "Good Afternoon,";
    } else {
      return "Good Morning,";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: UserFireCrud.fetchUsersWithId(widget.uid),
                builder: (ctx, snaps){
                  if(snaps.hasData){
                    UserModel user = snaps.data!;
                    return Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Container(
                            height: size.height * 0.3,
                            width: size.height * 0.4,
                            //color: Colors.red,
                            child: Lottie.asset(
                              'assets/profileanim.json',fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    );
                  }return Container();
                },
              ),
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
                                        Icon(Icons.person,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text:
                                          "Name :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text:
                                          "${user.firstName!} ${user.lastName!}",
                                          style: TextStyle(
                                              color: Colors.grey,
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
                                        Icon(Icons.cake,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: "Date of Birth :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: user.dob!,
                                          style: TextStyle(
                                              color: Colors.grey,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.notes,color: Constants().primaryAppColor,),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            child: KText(
                                              text: "About :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Constants()
                                                      .getFontSize(
                                                      context, 'S')),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: KText(
                                              text: user.about!,
                                              style: TextStyle(
                                                  color: Colors.grey,
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
                                        Icon(Icons.phone,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: "Phone :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: user.phone!,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: "Email :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: user.email!,
                                          style: TextStyle(
                                              color: Colors.grey,
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
                                        Icon(Icons.notes,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: "Marital Status : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: user.maritialStatus!,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: user.maritialStatus == "Married",
                                    child: InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Icon(Icons.event,color: Constants().primaryAppColor,),
                                          const SizedBox(width: 10),
                                          KText(
                                            text: "Anniversary date : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
                                          ),
                                          const SizedBox(width: 5),
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
                                        Icon(Icons.location_pin,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        KText(
                                          text: "Locality :",
                                          style: TextStyle(

                                              fontWeight: FontWeight.w700,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        ),
                                        const SizedBox(width: 5),
                                        KText(
                                          text: user.locality!,
                                          style: TextStyle(
                                              color: Colors.grey,
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
                                        Icon(Icons.cases_sharp,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          child: KText(
                                            text: "Profession : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: KText(
                                            text: user.profession!,
                                            style: TextStyle(
                                              color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
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
                                        Icon(Icons.location_city,color: Constants().primaryAppColor,),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          child: KText(
                                            text: "Address :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: Constants()
                                                    .getFontSize(
                                                    context, 'S')),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: KText(
                                            text: user.address!,
                                            style: TextStyle(
                                              color: Colors.grey,
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
      ),
    );
  }

  showEditProfilePopUp(context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "EDIT PROFILE",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Description",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: descriptionController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (descriptionController.text != "") {
                                  Response response =
                                  await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.email!,
                                  );
                                  if (response.code == 200) {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Update",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  descriptionController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showContactAdminPopUp(
      BuildContext context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Contact Admin",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Message",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: descriptionController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (descriptionController.text != "") {
                                  Response response =
                                  await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.email!,
                                  );
                                  if (response.code == 200) {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Update",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  descriptionController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

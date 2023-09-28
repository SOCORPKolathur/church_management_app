import 'package:church_management_client/Widgets/snackbar.dart';
import 'package:church_management_client/views/register_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/custom_textfield.dart';
import '../constants.dart';
import 'otp_verification_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/dolomite-alps-peaks-italy 1.png"),
            )),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.white70,
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: size.height * 0.35),
                    Column(
                      children: [
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            color: const Color(0xff757879),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Kindly enter your login details",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: const Color(0xff757879),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: size.height * 0.12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextField(
                          icon: Icons.phone,
                          hint: "Phone",
                          passType: false,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            authenticate();
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: GoogleFonts.openSans(
                                    fontSize: 17,
                                    color: const Color(0xffFFFFFF),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    InkWell(
                      onTap: () {
                        showNewRegisterPopUp(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: const Color(0xff757879)),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Sign Up',
                              style: GoogleFonts.openSans(
                                color: Constants().primaryAppColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  authenticate() async {
    bool isRegistered = false;
    var document = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < document.docs.length; i++) {
      if (document.docs[i]['phone'] == emailController.text) {
        isRegistered = true;
      }
    }
    if(isRegistered){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) =>
                  OtpVerificationView(phone: emailController.text)));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  showNewRegisterPopUp(context) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.5,
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
                  height: size.height * 0.3,
                  child: Lottie.asset("assets/thinking.json"),
                ),
                Text(
                  "You are new us. \n Resgiter with church",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const RegisterView()));
                  },
                  child: Container(
                    height: 40,
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(1, 2),
                        )
                      ],
                      border: Border.all(color: Constants().primaryAppColor),
                    ),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Constants().primaryAppColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Your Registeration not completed.",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ],
        )),
  );
}

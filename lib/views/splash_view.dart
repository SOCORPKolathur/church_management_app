import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'intro_view.dart';
import 'main_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    _navigateToNextScreen();
    super.initState();
  }

  Future<void> _navigateToNextScreen() async {
    var document = await FirebaseFirestore.instance.collection("Users").get();
    await Future.delayed(const Duration(seconds: 1));
    if(user != null){
      for(int i=0;i<document.docs.length;i++){
        if(document.docs[i]['id']==user!.uid){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => MainView(uid: user!.uid,phone: user!.phoneNumber!, userDocId: document.docs[i].id)));
        }
      }
    }else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const IntroView()));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/logo1.jpg"),
            SizedBox(height: size.height/57.733333333),
            Text(
              "BCAG CHURCH",
              style: TextStyle(
                color: Constants().primaryAppColor,
                fontSize: size.width/10.275,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
                fontFamily: "ArgentumSans",
              ),
            ),
            SizedBox(height: size.height/57.733333333),
            Text(
                "May the lord with us",
                style: GoogleFonts.amaranth(
                  color: Constants().primaryAppColor,
                  fontSize: size.width/29.357142857,
                  fontWeight: FontWeight.bold,
                )
            ),
          ],
        ),
      ),
    );
  }
}

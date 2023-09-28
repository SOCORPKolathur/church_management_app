import 'package:church_management_client/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'login_view.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/dolomite-alps-peaks-italy 1.png"),
                )
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.white70,
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: size.height* 0.26),
                  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Icon(
                       Icons.church,
                       size: 80,
                     ),
                     const SizedBox(height: 15),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                             "Welcome to",
                           style: GoogleFonts.openSans(
                             fontSize: 20,
                             fontWeight: FontWeight.w900,
                           ),
                         ),
                         Text(
                           "CHURCH",
                           style: GoogleFonts.openSans(
                             fontSize: 40,
                             fontWeight: FontWeight.w900,
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 8),
                     Text(
                         "May the lord with us",
                         style: GoogleFonts.openSans(
                           color:const Color(0xff000000),
                           fontSize: 14,
                           fontWeight: FontWeight.w700,
                         )
                     ),
                   ],
                 ),
                  SizedBox(height: size.height* 0.1),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const LoginView()));
                            },
                            child: Container(
                              height: 50,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.openSans(
                                  color: const Color(0xffFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const RegisterView()));
                            },
                            child: Container(
                              height: 50,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(1,1),
                                    blurRadius: 2,
                                  )
                                ]
                              ),
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.openSans(
                                    color: const Color(0xff000000),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Or login with",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color(0xff000000)
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap:(){},
                            child: Container(
                              height: 44,
                              width: size.width*0.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Constants().primaryAppColor, width: 2),
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/Group 10.svg"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap:(){},
                            child: Container(
                              height: 44,
                              width: size.width*0.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Constants().primaryAppColor, width: 2),
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/Group 9.svg"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap:(){},
                            child: Container(
                              height: 44,
                              width: size.width*0.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Constants().primaryAppColor, width: 2),
                              ),
                              child:  Center(
                                child: SvgPicture.asset("assets/Vector.svg"),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.04)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

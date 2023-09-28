import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/response.dart';
import '../services/user_register_firecrud.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: KText(
          text: "Register",
          style: GoogleFonts.openSans(
            color: Constants().primaryAppColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: KText(
                  text: "The Ultimate tool for church management",
                  style: TextStyle(),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              KText(
                text: "Members Details",
                style: GoogleFonts.openSans(
                  color: Constants().primaryAppColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              KText(
                text: "Members Details",
                style: GoogleFonts.openSans(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'First Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'Last Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.phone, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emailNameController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.mail, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'Email Id',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                      suffixIcon:
                          Icon(Icons.maps_home_work_outlined, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'City',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Center(
                child: InkWell(
                  onTap: () async {
                    if (firstNameController.text != "" &&
                        lastNameController.text != "" &&
                        emailNameController.text != "" &&
                        phoneController.text != "" &&
                        cityController.text != "") {
                      Response response =
                          await UserRegisterFireCrud.addUserRegister(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        phone: phoneController.text,
                        email: emailNameController.text,
                        city: cityController.text,
                      );
                      if (response.code == 200) {
                        await CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Registered successfully!",
                            width: size.width * 0.4,
                            backgroundColor: Constants()
                                .primaryAppColor
                                .withOpacity(0.8));
                        Navigator.pop(context);
                      } else {
                        await CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: "Registered failed!",
                            width: size.width * 0.4,
                            backgroundColor: Constants()
                                .primaryAppColor
                                .withOpacity(0.8));
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: KText(
                        text: "Register",
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

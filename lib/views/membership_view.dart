import 'package:church_management_client/views/members_previous_payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';

class MembershipView extends StatefulWidget {
  const MembershipView({super.key, required this.phone});

  final String phone;

  @override
  State<MembershipView> createState() => _MembershipViewState();
}

class _MembershipViewState extends State<MembershipView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: Constants().primaryAppColor,
          elevation: 0,
          title: Text(
            "Membership",
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: Constants().getFontSize(context, "XL"),
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          child: FutureBuilder<List<MembershipModel>>(
            future: getSubscripitonDetails(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snap.data!.length,
                        itemBuilder: (ctx, i) {
                          var data = snap.data![i];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if(!data.isPaid){
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      text: "Online payment currently unavailable. Please contact admin.",
                                      width: size.width * 0.4,
                                      backgroundColor: Constants()
                                          .primaryAppColor
                                          .withOpacity(0.8));
                                }
                              },
                              child: checkUpcomingMonth(data.month) ? Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: width / 1.1,
                                  height: data.isPaid ? height / 9.0 : height / 14.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: data.isPaid ? MainAxisAlignment.start : MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: width / 29,
                                              top: height / 94.5,
                                              bottom: height / 151.2,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width / 1.5,
                                                  child: Text(
                                                    data.month,
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: width / 20,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          data.isPaid ? Column(
                                            children: [
                                              SizedBox(height: height / 130.6),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width / 30,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      data.isPaid
                                                          ? "Payed On : " + data.payedOn
                                                          : "Due",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: width / 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ) : Container()
                                        ],
                                      ),
                                      Center(
                                        child: Material(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(100),
                                            topLeft: Radius.circular(100),
                                          ),
                                          elevation: 2,
                                          child: Container(
                                            height: height / 25.3,
                                            width: width / 3.88,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(100),
                                                topLeft: Radius.circular(100),
                                              ),
                                              color: data.isPaid ? Colors.green :  Colors.red,
                                            ),
                                            child: Center(
                                              child: Text(
                                                data.isPaid
                                                    ? "Paid"
                                                    : "Over Due",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: width / 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ) : Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: width / 1.1,
                                  height: height / 14.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width / 29,
                                          top: height / 94.5,
                                          bottom: height / 151.2,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: width / 1.5,
                                              child: Text(
                                                data.month,
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width / 20,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Material(
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(100),
                                                topLeft: Radius.circular(100),
                                              ),
                                              elevation: 2,
                                              child: Container(
                                                height: height / 25.3,
                                                width: width / 3.88,
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(
                                                    bottomLeft: Radius.circular(100),
                                                    topLeft: Radius.circular(100),
                                                  ),
                                                  color: Constants().primaryAppColor,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Upcoming',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: width / 26,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MembersPreviuosPayments(uid: memberId)));
                        },
                        child: Container(
                          height: height/18.975,
                          decoration: BoxDecoration(
                            color: Constants().primaryAppColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "View Previuos Records",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: width/19.6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Container(
                child: Center(
                  child: Lottie.asset(
                    'assets/churchLoading.json',
                    fit: BoxFit.contain,
                    height: size.height * 0.4,
                    width: size.width * 0.7,
                  ),
                ),
              );
            },
          ),
        )
        /*body: Column(
        children: [
          Text("Membership report"),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Members").doc("").collection("Membership").snapshots(),
              builder: (context,sanp){
            return ListView.builder(
                itemCount:  sanp.data!.docs.length,

                itemBuilder: (context,index){

              if(!dueMonths.contains(sanp.data!.docs[index]["month"])){
                return Text("${sanp.data!.docs[index]["month"]} is ");
              }
              return Text(sanp.data!.docs[index]["month"]);
            });
          }),
          Text("Previous Payments"),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Members").doc("").collection("Membership").snapshots(),
              builder: (context,sanp){
                return ListView.builder(itemBuilder: (context,index){
                  return Text(sanp.data!.docs[index]["month"]);
                });
              })
        ],
      ),*/
        );
  }

  bool checkUpcomingMonth(String date) {
    bool isFuture = false;
    DateTime paymentDate = DateFormat('MMM yyyy').parse(date);
    int num = DateTime.now().difference(paymentDate).inDays;
    if (num > 0) {
      isFuture = true;
    } else {
      isFuture = false;
    }
    return isFuture;
  }

  bool checkCurrentMonth(String date) {
    bool isCurrent = false;
    DateTime paymentDate = DateFormat('MMM yyyy').parse(date);
    print(paymentDate.year);
    print(paymentDate.month);
    if (paymentDate.month == DateTime.now().month &&
        paymentDate.year == DateTime.now().year) {
      isCurrent = true;
    } else {
      isCurrent = false;
    }
    return isCurrent;
  }

  List totalMonths = [];
  String memberId = '';
  List dueMonths = [];
  List pendingMonths = [];
  List unpaidmonts = [];

  func() async {
    setState(() {
      pendingMonths.clear();
      dueMonths.clear();
      totalMonths.clear();
    });

    var docu = await FirebaseFirestore.instance
        .collection("Members")
        .doc("")
        .collection("Membership")
        .get();
    print(DateTime.now().add(Duration(days: 80)).month);
    print(DateTime.now().subtract(Duration(days: 80)).month);
    for (int i = 0;
        i <
            DateTime.now()
                .add(Duration(days: 80))
                .difference(DateTime.now().subtract(Duration(days: 80)))
                .inDays;
        i++) {
      if (!totalMonths.contains(DateFormat('MMM yyyy').format(DateTime.now()
          .subtract(Duration(days: 80))
          .add(Duration(days: i))))) {
        totalMonths.add(DateFormat('MMM yyyy').format(DateTime.now()
            .subtract(Duration(days: 80))
            .add(Duration(days: i))));
      }
    }
    for (int i = 0;
        i <
            DateTime.now()
                .difference(DateTime.now().subtract(Duration(days: 80)))
                .inDays;
        i++) {
      if (!dueMonths.contains(DateFormat('MMM yyyy').format(DateTime.now()
          .subtract(Duration(days: 80))
          .add(Duration(days: i))))) {
        dueMonths.add(DateFormat('MMM yyyy').format(DateTime.now()
            .subtract(Duration(days: 80))
            .add(Duration(days: i))));
      }
    }
    for (int i = 0;
        i <
            DateTime.now()
                .add(Duration(days: 80))
                .difference(DateTime.now())
                .inDays;
        i++) {
      if (!pendingMonths.contains(DateFormat('MMM yyyy')
              .format(DateTime.now().add(Duration(days: i)))) &&
          DateFormat('MMM yyyy')
                  .format(DateTime.now().add(Duration(days: i))) !=
              DateFormat('MMM yyyy').format(DateTime.now())) {
        pendingMonths.add(DateFormat('MMM yyyy')
            .format(DateTime.now().add(Duration(days: i + 1))));
      }
    }
    print(totalMonths);
    print(pendingMonths);
    print(dueMonths);
    for (int i = 0; i < docu.docs.length; i++) {
      for (int j = 0; j < dueMonths.length; j++) {}
    }
  }

  Future<List<MembershipModel>> getSubscripitonDetails() async {
    List<String> totalMonths = [];
    List<String> pendingMonths = [];
    List<String> overdueMonths = [];
    List<MembershipModel> dueMonths = [];
    List<MembershipModel> paidMonths = [];
    List<MembershipModel> pendMonths = [];
    List<MembershipModel> result = [];
    List<MembershipModel> result1 = [];
    //if(val == '3'){
    for (int i = 0;
        i <
            DateTime.now()
                .add(Duration(days: 80))
                .difference(DateTime.now().subtract(Duration(days: 80)))
                .inDays;
        i++) {
      if (!totalMonths.contains(DateFormat('MMM yyyy').format(DateTime.now()
          .subtract(Duration(days: 80))
          .add(Duration(days: i))))) {
        totalMonths.add(DateFormat('MMM yyyy').format(DateTime.now()
            .subtract(Duration(days: 80))
            .add(Duration(days: i))));
      }
    }
    //}

    //else if(val == '6'){
    for (int i = 0;
        i <
            DateTime.now()
                .difference(DateTime.now().subtract(Duration(days: 80)))
                .inDays;
        i++) {
      if (!overdueMonths.contains(DateFormat('MMM yyyy').format(DateTime.now()
          .subtract(Duration(days: 80))
          .add(Duration(days: i))))) {
        overdueMonths.add(DateFormat('MMM yyyy').format(DateTime.now()
            .subtract(Duration(days: 80))
            .add(Duration(days: i))));
      }
    }
    //}
    // else{
    for (int i = 0;
        i <
            DateTime.now()
                .add(Duration(days: 80))
                .difference(DateTime.now())
                .inDays;
        i++) {
      if (!pendingMonths.contains(DateFormat('MMM yyyy')
              .format(DateTime.now().add(Duration(days: i)))) &&
          DateFormat('MMM yyyy')
                  .format(DateTime.now().add(Duration(days: i))) !=
              DateFormat('MMM yyyy').format(DateTime.now())) {
        pendingMonths.add(DateFormat('MMM yyyy')
            .format(DateTime.now().add(Duration(days: i + 1))));
      }
    }
    //}

    print(totalMonths);
    print(overdueMonths);
    print(pendingMonths);

    var members = await FirebaseFirestore.instance.collection('Members').get();
    members.docs.forEach((member) {
      if (widget.phone == member.get("phone")) {
        memberId = member.id;
      }
    });
    var membershipDocument = await FirebaseFirestore.instance
        .collection('Members')
        .doc(memberId)
        .collection('Membership')
        .orderBy("timestamp", descending: true)
        .get();

    membershipDocument.docs.forEach((membership) {
      if (totalMonths.contains(membership.get("month"))) {
        paidMonths.add(MembershipModel(
          month: membership.get("month"),
          isPaid: true,
          payedOn: membership.get("date"),
          amount: membership.get("amount"),
        ));
      }
      if (overdueMonths.contains(membership.get("month"))) {
        overdueMonths.remove(membership.get("month"));
      }
      if (pendingMonths.contains(membership.get("month"))) {
        pendingMonths.remove(membership.get("month"));
      }
    });

    overdueMonths.forEach((element) {
      dueMonths.add(MembershipModel(
          month: element, isPaid: false, payedOn: '', amount: ''));
    });

    pendingMonths.forEach((element) {
      pendMonths.add(MembershipModel(
          month: element, isPaid: false, payedOn: '', amount: ''));
    });

    paidMonths.forEach((element) {
      print(element.month);
      result.add(element);
    });
    dueMonths.forEach((element) {
      print(element.month);
      result.add(element);
    });
    pendMonths.forEach((element) {
      print(element.month);
      result.add(element);
    });
    result.forEach((element) {
      result1.add(element);
    });
    result1.sort((a, b) => DateFormat('MMM yyyy')
        .parse(a.month)
        .compareTo(DateFormat('MMM yyyy').parse(b.month)));
    return result1;
  }
}

class MembershipDataModel {
  MembershipDataModel(
      {required this.totalMonths,
      required this.dueMonths,
      required this.pendingMonths});

  List<MembershipModel> totalMonths;
  List<MembershipModel> dueMonths;
  List<MembershipModel> pendingMonths;
}

class MembershipModel {
  MembershipModel(
      {required this.month,
      required this.isPaid,
      required this.payedOn,
      required this.amount});

  String month;
  String payedOn;
  String amount;
  bool isPaid;
}

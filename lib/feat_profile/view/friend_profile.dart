import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// model
import 'package:week7_networking_discussion/models/person/index.dart';

// color import
import 'package:week7_networking_discussion/config/theme/index.dart';

class FriendProfilePage extends StatefulWidget {
  const FriendProfilePage({super.key});

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> friend = context.watch<AuthProvider>().clickedFriend;

    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return Scaffold(
      backgroundColor: BrandColor.primary.shade50,
      appBar: AppBar(
        title: Text(
          "Friend's Profile",
          style: TextStyle(
              color: BrandColor.background.shade600,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: BrandColor.primary.shade50,
        shadowColor: const Color.fromRGBO(255, 255, 255, 1).withOpacity(0),
        leading: BackButton(color: BrandColor.background.shade600),
      ),
      body: StreamBuilder(
        stream: friend,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No User Found"),
            );
          }

          Person user = Person.fromJSON(
              snapshot.data?.docs[0].data() as Map<String, dynamic>);
          return ListView(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(90),
                    decoration:
                        BoxDecoration(color: BrandColor.primary.shade50),
                  ),
                  Container(
                      padding: const EdgeInsets.all(60),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              BrandColor.primary.withOpacity(1),
                              const Color.fromRGBO(149, 202, 243, 1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      )),
                  Positioned(
                    top: 95,
                    left: 20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            color: BrandColor.primary.shade50,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            color: BrandColor.primary,
                          ),
                          // padding: EdgeInsets.all(20),
                          width: 68,
                          height: 68,
                          child: Center(
                              child: Text(
                            user.firstName[0],
                            style: TextStyle(
                                color: BrandColor.primary.shade50,
                                fontSize: 30,
                                fontWeight: FontWeight.w900),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 125,
                    left: 110,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: BrandColor.primary.shade900),
                          ),
                          Text("@${user.userName}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: BrandColor.primary)),
                        ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: BrandColor.primary.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: BrandColor.primary.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profile",
                              style: TextStyle(
                                  color: BrandColor.background.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Icon(
                                Icons.cake,
                                color: BrandColor.warning.shade600,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "${months[user.birthDay.month - 1]} ${user.birthDay.day}, ${user.birthDay.year}",
                                style: TextStyle(
                                  color: BrandColor.background.shade400,
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Icon(Icons.map,
                                  color: BrandColor.warning.shade600),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                user.location.toString(),
                                style: TextStyle(
                                  color: BrandColor.background.shade400,
                                ),
                              ),
                            ]),
                            user.bio != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "About Me",
                                        style: TextStyle(
                                            color:
                                                BrandColor.background.shade400,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user.bio!,
                                        style: TextStyle(
                                          color: BrandColor.background.shade400,
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Kindly inform this user that they still do not have any bio.',
                                      style: TextStyle(
                                        color: BrandColor.background.shade400,
                                      ),
                                    ))
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// lib import
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// component import
import './editProfile.dart';

// Pages Import
import './friend_requests.dart';
import './friends.dart';
import './pending.dart';
import './search.dart';
import 'package:week7_networking_discussion/feat_todo/view/todo_page.dart';
import 'package:week7_networking_discussion/feat_todo/view/todo_friends.dart';

// provider
import 'package:week7_networking_discussion/providers/user_provider.dart';

// model
import 'package:week7_networking_discussion/models/person/index.dart';

// color import
import 'package:week7_networking_discussion/config/theme/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> user = context.watch<AuthProvider>().loggedUser;
    String? id = context.watch<AuthProvider>().userId;

    TextEditingController _bioEditController = TextEditingController();

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
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ])),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
              color: BrandColor.background.shade600,
              fontWeight: FontWeight.w700),
        ),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.sort),
                  color: BrandColor.background.shade600,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
        backgroundColor: BrandColor.primary.shade50,
        shadowColor: const Color.fromRGBO(255, 255, 255, 1).withOpacity(0),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: BrandColor.primary),
            onPressed: () {
              context
                  .read<UserProvider>()
                  .getPeopleUserMightKnow(userID: id ?? "");

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: user,
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
                  Positioned(
                      top: 130,
                      right: 25,
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: BrandColor.primary.shade700
                                    .withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                // offset: const Offset(0, 2),
                              )
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: BrandColor.primary.shade500,
                                    width: sqrt2),
                                backgroundColor: BrandColor.primary.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      EditModal(type: 'bio', id: id ?? ""));
                            },
                            child: Center(
                                child: Text(
                              user.bio == null ? "Add Bio" : "Edit Bio",
                              style: TextStyle(
                                  color: BrandColor.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ))),
                      ))
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
                              IconButton(
                                onPressed: () => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          EditModal(
                                              type: 'birthday', id: id ?? ""))
                                },
                                icon: const Icon(Icons.edit),
                                color: BrandColor.background.shade600,
                                iconSize: 18,
                              )
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
                              IconButton(
                                onPressed: () => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          EditModal(
                                              type: 'location', id: id ?? ""))
                                },
                                icon: const Icon(Icons.edit),
                                color: BrandColor.background.shade600,
                                iconSize: 18,
                              )
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
                                : const SizedBox()
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Friends",
                                    style: TextStyle(
                                        color: BrandColor.background.shade400),
                                  ),
                                  Text(
                                    user.friends.length.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: BrandColor.primary.shade600),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<UserProvider>()
                                  .fetchFriends(userID: user.id.toString());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FriendsPage()));
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Request",
                                      style: TextStyle(
                                          color:
                                              BrandColor.background.shade400)),
                                  Text(
                                    user.friendRequests.length.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: BrandColor.primary.shade600),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              context.read<UserProvider>().fetchFriendRequests(
                                  userID: user.id.toString());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FriendRequestPage()));
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Pending",
                                      style: TextStyle(
                                          color:
                                              BrandColor.background.shade400)),
                                  Text(
                                    user.sentFriendRequests.length.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: BrandColor.primary.shade600),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<UserProvider>()
                                  .fetchSentFriendRequests(
                                      userID: user.id.toString());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PendingRequestsPage()));
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(40),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          // Button press logic
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TodoFriendsPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BrandColor.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text('View Todos of Friends',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: BrandColor.primary.shade50))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColor.primary.shade50,
        child: Icon(Icons.edit, color: BrandColor.primary),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TodoPage()));
        },
      ),
    );
  }
}

// lib import
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// Pages Import
import './friend_requests.dart';
import './friends.dart';
import './pending.dart';
import './search.dart';
import 'package:week7_networking_discussion/feat_todo/view/todo_page.dart';

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
          return Column(
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
                        width: 60,
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
                              context
                                  .read<UserProvider>()
                                  .getPeopleUserMightKnow(
                                      userID: user.id.toString());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchPage()));
                            },
                            child: Center(
                                child: Text(
                              "Edit",
                              style: TextStyle(
                                  color: BrandColor.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ))),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Friends"),
                          Text(
                            user.friends.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                              builder: (context) => const FriendsPage()));
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Requests"),
                          Text(
                            user.friendRequests.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      context
                          .read<UserProvider>()
                          .fetchFriendRequests(userID: user.id.toString());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendRequestPage()));
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Pending"),
                          Text(
                            user.sentFriendRequests.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      context
                          .read<UserProvider>()
                          .fetchSentFriendRequests(userID: user.id.toString());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PendingRequestsPage()));
                    },
                  ),
                ],
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

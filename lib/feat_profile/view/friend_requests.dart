// lib import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/config/theme/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provder
import 'package:week7_networking_discussion/providers/index.dart';

// model
import 'package:week7_networking_discussion/models/index.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> friendRequests =
        context.watch<UserProvider>().friendRequests;
    String? loggedUserID = context.watch<AuthProvider>().userId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Requests",
            style: TextStyle(
                color: BrandColor.primary.shade50,
                fontWeight: FontWeight.w700)),
        backgroundColor: BrandColor.primary,
        leading: BackButton(color: BrandColor.primary.shade50),
      ),
      body: Container(
          margin: const EdgeInsets.all(30),
          child: StreamBuilder(
            stream: friendRequests,
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
                return Center(
                  child: Text("No Friend Requests Found",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BrandColor.background.shade800)),
                );
              } else if (snapshot.data != null && snapshot.data?.docs != null) {
                List<QueryDocumentSnapshot<Object?>>? docs =
                    snapshot.data?.docs;

                if (docs != null && docs.isEmpty) {
                  return Center(
                    child: Text("No Friend Requests Found",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: BrandColor.background.shade800)),
                  );
                }
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Person requesterUser = Person.fromJSON(
                      snapshot.data?.docs[index].data()
                          as Map<String, dynamic>);

                  return Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      color: BrandColor.primary),
                                  // padding: EdgeInsets.all(20),
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    requesterUser.firstName[0].toUpperCase(),
                                    style: TextStyle(
                                        color: BrandColor.primary.shade50,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${requesterUser.firstName} ${requesterUser.lastName}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                BrandColor.background.shade500),
                                      ),
                                      Text(
                                        "@${requesterUser.userName}",
                                        style: TextStyle(
                                            color: BrandColor.primary),
                                      )
                                    ]),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ConfirmModal(
                                            passive: false,
                                            title:
                                                "Accept @${requesterUser.userName} as friend",
                                            modalBody:
                                                "Are you sure you want to add ${requesterUser.firstName} to your friends?",
                                            confirm: () async {
                                              await context
                                                  .read<UserProvider>()
                                                  .acceptFriendRequest(
                                                      loggedUserID:
                                                          loggedUserID ?? "",
                                                      requesterUserID:
                                                          requesterUser.id
                                                              .toString());
                                            }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(30, 30),
                                      shape: const CircleBorder(),
                                      backgroundColor:
                                          BrandColor.success.shade700,
                                      foregroundColor:
                                          BrandColor.primary.shade50),
                                  child: const Icon(
                                    Icons.check,
                                    size: 15,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ConfirmModal(
                                            passive: true,
                                            title:
                                                "Reject @${requesterUser.userName} as friend",
                                            modalBody:
                                                "Are you sure you want to reject ${requesterUser.firstName}'s friend request?",
                                            confirm: () async {
                                              await context
                                                  .read<UserProvider>()
                                                  .rejectFriendRequest(
                                                      loggedUserID:
                                                          loggedUserID ?? "",
                                                      requesterUserID:
                                                          requesterUser.id
                                                              .toString());
                                            }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(30, 30),
                                      shape: const CircleBorder(),
                                      backgroundColor: BrandColor.error,
                                      foregroundColor:
                                          BrandColor.primary.shade50),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 15,
                                  ),
                                ),
                              ],
                            )
                          ]));
                }),
              );
            },
          )),
    );
  }
}

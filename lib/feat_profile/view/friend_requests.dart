// lib import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provder
import '../provider/index.dart';

// model
import '../model/index.dart';

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
      appBar: AppBar(title: const Text("Friend Requests")),
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
                return const Center(
                  child: Text("No Friend Requests Found"),
                );
              } else if (snapshot.data != null && snapshot.data?.docs != null) {
                List<QueryDocumentSnapshot<Object?>>? docs =
                    snapshot.data?.docs;

                if (docs != null && docs.isEmpty) {
                  return const Center(
                    child: Text("No Friend Requests Found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color:
                                          Color.fromARGB(255, 201, 203, 204)),
                                  // padding: EdgeInsets.all(20),
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    requesterUser.userName[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 32, 32, 35),
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
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("@${requesterUser.userName}")
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
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white),
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
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
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

// lib import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/config/theme/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provider
import 'package:week7_networking_discussion/providers/index.dart';

// model
import 'package:week7_networking_discussion/models/index.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => PendingRequestsPageState();
}

class PendingRequestsPageState extends State<PendingRequestsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> pendingFriend =
        context.watch<UserProvider>().pendingFriendRequests;
    String? requesterUserID = context.watch<AuthProvider>().userId;

    return Scaffold(
      appBar: AppBar(
          title: Text("Pending Requests",
              style: TextStyle(
                  color: BrandColor.primary.shade50,
                  fontWeight: FontWeight.w700)),
          backgroundColor: BrandColor.primary,
          leading: BackButton(color: BrandColor.primary.shade50)),
      body: Container(
          margin: const EdgeInsets.all(30),
          child: StreamBuilder(
            stream: pendingFriend,
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
                  child: Text("No Pending Friend Requests Found"),
                );
              } else if (snapshot.data != null && snapshot.data?.docs != null) {
                List<QueryDocumentSnapshot<Object?>>? docs =
                    snapshot.data?.docs;

                if (docs != null && docs.isEmpty) {
                  return const Center(
                    child: Text("No Pending Friend Requests Found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Person receiverUser = Person.fromJSON(
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
                                    receiverUser.firstName[0].toUpperCase(),
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
                                        "${receiverUser.firstName} ${receiverUser.lastName}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                BrandColor.background.shade500),
                                      ),
                                      Text(
                                        "@${receiverUser.userName}",
                                        style: TextStyle(
                                            color: BrandColor.primary),
                                      )
                                    ]),
                              ],
                            ),
                            OutlinedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) => ConfirmModal(
                                        passive: true,
                                        title:
                                            "Cancel friend request to @${receiverUser.userName}",
                                        modalBody:
                                            "Are you sure you want to cancel your friend request for ${receiverUser.firstName}?",
                                        confirm: () async => {
                                              await context
                                                  .read<UserProvider>()
                                                  .cancelSentFriendRequest(
                                                      senderFriendRequestID:
                                                          requesterUserID ?? "",
                                                      receiverFriendRequestID:
                                                          receiverUser.id
                                                              .toString())
                                            })));
                              },
                              style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(1),
                                  side: BorderSide(
                                      width: 1.0, color: BrandColor.error),
                                  fixedSize: const Size(35, 35)),
                              child: Icon(
                                Icons.delete,
                                color: BrandColor.error,
                                size: 18,
                              ),
                            ),
                          ]));
                }),
              );
            },
          )),
    );
  }
}

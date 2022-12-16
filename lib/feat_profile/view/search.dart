import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/config/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provider
import 'package:week7_networking_discussion/providers/index.dart';

// model
import 'package:week7_networking_discussion/models/index.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  String _searchField = "";

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> pendingFriend =
        context.watch<UserProvider>().searchStream;
    String? requesterUserID = context.watch<AuthProvider>().userId;

    return Scaffold(
      appBar: AppBar(
          title: Text("Search People",
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
                  child: Text("No Search Items Found"),
                );
              } else if (snapshot.data != null && snapshot.data?.docs != null) {
                List<QueryDocumentSnapshot<Object?>>? docs =
                    snapshot.data?.docs;

                if (docs != null && docs.isEmpty) {
                  return const Center(
                    child: Text("No Search Items Found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }
              }

              return Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Find friend by display name...",
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            _searchField = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "People you might know",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: BrandColor.background.shade700),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    Person receiverUser = Person.fromJSON(
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>);

                    if (receiverUser.id.toString() == requesterUserID) {
                      return const SizedBox();
                    }

                    if (receiverUser.friends.contains(requesterUserID) ||
                        receiverUser.friendRequests.contains(requesterUserID) ||
                        receiverUser.sentFriendRequests
                            .contains(requesterUserID)) {
                      return const SizedBox();
                    }

                    if (!receiverUser.fullName
                        .toLowerCase()
                        .contains(_searchField.toLowerCase())) {
                      return const SizedBox();
                    }

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
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      receiverUser.firstName[0].toUpperCase(),
                                      style: TextStyle(
                                        color: BrandColor.primary.shade50,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
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
                                              color: BrandColor
                                                  .background.shade500),
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
                                          passive: false,
                                          title:
                                              "Send friend request to @${receiverUser.userName}",
                                          modalBody:
                                              "Are you sure you want to send a friend request for ${receiverUser.firstName}?",
                                          confirm: () async => {
                                                await context
                                                    .read<UserProvider>()
                                                    .sendFriendRequest(
                                                        senderFriendRequestID:
                                                            requesterUserID ??
                                                                "",
                                                        receiverFriendRequestID:
                                                            receiverUser.id
                                                                .toString())
                                              })));
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(1),
                                    side: BorderSide(
                                        width: 1.0,
                                        color: BrandColor.success.shade700),
                                    fixedSize: const Size(35, 35)),
                                child: Icon(
                                  Icons.person_add,
                                  color: BrandColor.success.shade700,
                                  size: 18,
                                ),
                              )
                            ]));
                  }),
                ))
              ]);
            },
          )),
    );
  }
}

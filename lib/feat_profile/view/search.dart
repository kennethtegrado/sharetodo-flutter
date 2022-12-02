import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provder
import '../provider/index.dart';

// model
import '../model/index.dart';

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
      appBar: AppBar(title: const Text("Search Page")),
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
                            hintText: "Find friend by display name..."),
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
                const Text(
                  "People you might know",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        color:
                                            Color.fromARGB(255, 201, 203, 204)),
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      receiverUser.userName[0].toUpperCase(),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 32, 32, 35),
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
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("@${receiverUser.userName}")
                                      ]),
                                ],
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => ConfirmModal(
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
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.green),
                                    fixedSize: const Size(35, 35)),
                                child: const Icon(
                                  Icons.person_add,
                                  color: Colors.green,
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

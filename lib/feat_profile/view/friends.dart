// lib import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// component import
import 'package:week7_networking_discussion/components/index.dart';
import 'package:week7_networking_discussion/feat_profile/view/friend_profile.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// provder
import 'package:week7_networking_discussion/providers/index.dart';

// model
import 'package:week7_networking_discussion/models/index.dart';

// brand color
import 'package:week7_networking_discussion/config/theme/index.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> friends = context.watch<UserProvider>().friends;
    String? userID = context.watch<AuthProvider>().userId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends",
            style: TextStyle(
                color: BrandColor.primary.shade50,
                fontWeight: FontWeight.w700)),
        backgroundColor: BrandColor.primary,
        leading: BackButton(color: BrandColor.primary.shade50),
      ),
      body: Container(
          margin: const EdgeInsets.all(30),
          child: StreamBuilder(
            stream: friends,
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
                  child: Text("No Friends Found"),
                );
              } else if (snapshot.data != null && snapshot.data?.docs != null) {
                List<QueryDocumentSnapshot<Object?>>? docs =
                    snapshot.data?.docs;

                if (docs != null && docs.isEmpty) {
                  return Center(
                    child: Text("No Friends Found",
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
                  Person user = Person.fromJSON(snapshot.data?.docs[index]
                      .data() as Map<String, dynamic>);

                  return InkWell(
                    onTap: () {
                      context.read<AuthProvider>().getFriend(id: user.id);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendProfilePage()));
                    },
                    child: Container(
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
                                      user.firstName[0].toUpperCase(),
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
                                          "${user.firstName} ${user.lastName}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: BrandColor
                                                  .background.shade500),
                                        ),
                                        Text(
                                          "@${user.userName}",
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
                                          title: "Unfriend @${user.userName}",
                                          modalBody:
                                              "Are you sure you want to unfriend ${user.firstName}?",
                                          confirm: () async => {
                                                await context
                                                    .read<UserProvider>()
                                                    .removeFriend(
                                                        firstUserID:
                                                            userID ?? "",
                                                        secondUserID:
                                                            user.id.toString())
                                              })));
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(1),
                                    side: BorderSide(
                                        width: 1.0, color: BrandColor.error),
                                    fixedSize: const Size(35, 35)),
                                child: Icon(
                                  Icons.person_remove_outlined,
                                  color: BrandColor.error,
                                  size: 18,
                                ),
                              ),
                            ])),
                  );
                }),
              );
            },
          )),
    );
  }
}

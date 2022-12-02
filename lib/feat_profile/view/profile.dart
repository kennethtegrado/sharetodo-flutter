import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

// Pages Import
import './friend_requests.dart';
import './friends.dart';
import './pending.dart';
import './search.dart';

// provider
import 'package:week7_networking_discussion/providers/user_provider.dart';

// model
import '../model/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> user = context.watch<AuthProvider>().loggedUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
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
              child: Text("No Person Found"),
            );
          }

          Person user = Person.fromJSON(
              snapshot.data?.docs[0].data() as Map<String, dynamic>);
          return Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TopView(name: user.firstName[0]),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                    Text("@${user.userName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.amber.shade800)),
                                  ],
                                ),
                                MaterialButton(
                                  color: Colors.blue,
                                  shape: const CircleBorder(),
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
                                  child: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                                )
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Bio:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.bio),
                          const SizedBox(height: 20)
                        ]),
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
                              Text(
                                user.friends.length.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Total"),
                              const Text("Friends"),
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
                              Text(
                                user.friendRequests.length.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Friend"),
                              const Text("Requests"),
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
                                  builder: (context) =>
                                      const FriendRequestPage()));
                        },
                      ),
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.sentFriendRequests.length.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Pending"),
                              const Text("Requests"),
                            ],
                          ),
                        ),
                        onTap: () {
                          context.read<UserProvider>().fetchSentFriendRequests(
                              userID: user.id.toString());

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
              ));
        },
      ),
    );
  }
}

class TopView extends StatelessWidget {
  final String name;
  const TopView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(60),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Color.fromARGB(255, 32, 32, 35)),
      ),
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 201, 203, 204)),
        // padding: EdgeInsets.all(20),
        width: 80,
        height: 80,
        transform: Matrix4.translationValues(10, -20.0, 0.0),
        child: Center(
            child: Text(
          name,
          style: const TextStyle(
              color: Color.fromARGB(255, 32, 32, 35),
              fontSize: 30,
              fontWeight: FontWeight.w900),
        )),
      ),
    ]);
  }
}

import "dart:convert";

class Person {
  String? id;
  String? bio;
  String? userName;
  String firstName;
  String fullName;
  String? lastName;
  DateTime? birthDay;
  String email;
  List<dynamic> friends = [];
  List<dynamic> friendRequests = [];
  List<dynamic> sentFriendRequests = [];
  int? age;

  Person(
      {required this.userName,
      required this.firstName,
      required this.lastName,
      this.id,
      required this.bio,
      required this.birthDay,
      required this.age,
      required this.friends,
      required this.friendRequests,
      required this.sentFriendRequests,
      required this.fullName,
      required this.email});

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(
        userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        bio: json["bio"],
        birthDay: json["birthDay"],
        age: json["age"],
        friends: json["friends"],
        sentFriendRequests: json["sentFriendRequests"],
        friendRequests: json["friendRequests"],
        fullName: '${json["firstName"]} ${json["lastName"]}',
        email: json["email"]);
  }

  /*
   userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        bio: json["bio"],
        birthDay: json["birthDay"],
        age: json["age"],
        friends: json["friends"],
        sentFriendRequests: json["sentFriendRequests"],
        friendRequests: json["friendRequests"],
        fullName: '${json["firstName"]} ${json["lastName"]}',
        email: json["email"]);
  */

  /*
  {id: 8sKx1jzSpehjeUVtMbmtIeMCsZz2, lastName: Tegrado, firstName: Kenneth, sentFriendRequests: [], age: 5, fullName: Kenneth Tegrado, userName: kent, birthDay: null, friends: [], bio: null, email: test@up.edu.ph,
friendRequests: []}
  */

  static List<Person> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Person>((dynamic d) => Person.fromJSON(d)).toList();
  }

  static Map<String, dynamic> toJson(Person person) {
    return {
      "userName": person.userName,
      "firstName": person.firstName,
      "lastName": person.lastName,
      "id": person.id,
      "bio": person.bio,
      "birthDay": person.birthDay,
      "age": person.age,
      "fullName": '$person.firstName $person.lastName',
      "friends": person.friends.toString(),
      "friendRequests": person.friendRequests.toString(),
      "sentFriendRequests": person.sentFriendRequests.toString()
    };
  }
}

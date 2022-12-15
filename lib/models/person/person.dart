import "dart:convert";

class Person {
  String id;
  String? bio;
  String? userName;
  String firstName;
  String fullName;
  String lastName;
  String location;
  DateTime birthDay;
  String email;
  List<dynamic> friends = [];
  List<dynamic> friendRequests = [];
  List<dynamic> sentFriendRequests = [];
  int? age;

  Person(
      {required this.userName,
      required this.firstName,
      required this.lastName,
      required this.id,
      required this.bio,
      required this.birthDay,
      required this.age,
      required this.friends,
      required this.friendRequests,
      required this.sentFriendRequests,
      required this.fullName,
      required this.email,
      required this.location});

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(
        userName: json["userName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        bio: json["bio"],
        birthDay: DateTime.parse(json["birthDay"]),
        age: DateTime.now().year - DateTime.parse(json["birthDay"]).year,
        friends: json["friends"],
        sentFriendRequests: json["sentFriendRequests"],
        friendRequests: json["friendRequests"],
        fullName: '${json["firstName"]} ${json["lastName"]}',
        email: json["email"],
        location: json["location"]);
  }

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
      "age": DateTime.now().year - person.birthDay.year,
      "fullName": '$person.firstName $person.lastName',
      "friends": person.friends.toString(),
      "friendRequests": person.friendRequests.toString(),
      "sentFriendRequests": person.sentFriendRequests.toString(),
      "email": person.email
    };
  }
}

// class Member {
//   String name;
//   int age;
//   bool isChild;
//   bool isPet;
//
//   Member({required this.name, required this.age, this.isChild = false, this.isPet = false});
// }
class Member {
  String firstName;
  String lastName;
  String dateOfBirth;
  int? id;
  bool isChild;
  bool isPet;

  Member({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.isChild = false,
    this.isPet = false,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'isChild': isChild,
      'isPet': isPet,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      isChild: map['isChild'] ?? false,
      isPet: map['isPet'] ?? false,
    );
  }
}

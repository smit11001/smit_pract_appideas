import 'member_model.dart';

class Room {
  String id;
  List<Member> members;
  bool hasPet;

  Room({required this.id, this.members = const [], this.hasPet = false});
}
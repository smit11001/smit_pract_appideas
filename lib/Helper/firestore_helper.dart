// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../Model/room_model.dart';
//
// class FirestoreHelper {
//   final CollectionReference roomsCollection =
//   FirebaseFirestore.instance.collection('rooms');
//
//   Future<void> syncDataWithFirestore(List<Room> rooms) async {
//     for (var room in rooms) {
//       Map<String, dynamic> roomData = {
//         'id': room.id,
//         'members': room.members.map((member) {
//           return {
//             'firstName': member.firstName,
//             'lastName': member.lastName,
//             'dateOfBirth': member.dateOfBirth,
//             'isChild': member.isChild,
//             'isPet': member.isPet,
//           };
//         }).toList(),
//       };
//
//       await roomsCollection.doc(room.id).set(roomData);
//     }
//   }
// }

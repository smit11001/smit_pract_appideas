
import 'package:flutter/material.dart';
import 'Model/member_model.dart';
import 'Model/room_model.dart';
import 'Widgets/room_widget.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({super.key});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  List<Room> rooms = [];

  void _addRoom() {
    setState(() {
      rooms.add(Room(id: 'Room ${rooms.length + 1}', members: []));
      print(rooms);
    });
  }

  void _addMemberToRoom(int roomIndex, Member member) {
    setState(() {
      if (rooms[roomIndex].members.length < 3) {
        rooms[roomIndex].members.add(member);
        print(rooms);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum 3 members allowed per room')),
        );
      }
    });
  }

  void _removeMemberFromRoom(int roomIndex, Member member) {
    setState(() {
      rooms[roomIndex].members.remove(member);
      if (member.isPet) {
        rooms[roomIndex].hasPet = false;
      }
    });
  }

  void _removeRoom(int roomIndex) {
    setState(() {
      rooms.removeAt(roomIndex);
    });
  }

  void _onSubmit() {
    // Check if there are any rooms to submit
    if (rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No rooms to submit')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submission Result'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rooms.map((room) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.id,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...room.members.map((member) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${member.firstName} ${member.lastName}, DOB: ${member.dateOfBirth} ${member.isChild ? '(Child)' : ''} ${member.isPet ? '(Pet)' : ''}',
                          ),
                        );
                      }).toList(),
                      Divider(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Room Booking')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return RoomWidget(
                  room: rooms[index],
                  addMember: (member) => _addMemberToRoom(index, member),
                  removeMember: (member) => _removeMemberFromRoom(index, member),
                  removeRoom: () => _removeRoom(index),
                  petOptionAvailable: rooms.every((r) => !r.hasPet),
                );
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom: 70),
            child: ElevatedButton(
              onPressed: _onSubmit,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Room'),
        onPressed: _addRoom,
        icon: Icon(Icons.add),
      ),
    );
  }
}

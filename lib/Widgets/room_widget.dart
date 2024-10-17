
import 'package:flutter/material.dart';
import '../Model/member_model.dart';
import '../Model/room_model.dart';

class RoomWidget extends StatefulWidget {
  final Room room;
  final Function(Member) addMember;
  final Function(Member) removeMember;
  final VoidCallback removeRoom;
  final bool petOptionAvailable;

  RoomWidget({
    required this.room,
    required this.addMember,
    required this.removeMember,
    required this.removeRoom,
    required this.petOptionAvailable,
  });

  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isChild = false;
  bool _hasPet = false;

  void _addMember() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dob = _dobController.text.trim();

    print('First Name: $firstName, Last Name: $lastName, DOB: $dob');

    if (firstName.isEmpty || lastName.isEmpty || dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final member = Member(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dob,
      isChild: _isChild,
      isPet: _hasPet,
    );

    widget.addMember(member);

    _firstNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
    setState(() {
      _isChild = false;
      _hasPet = false;
    });
  }

  @override
  void initState() {
    _dobController.text = "${selectedDate.toLocal()}".split(' ')[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.room.id,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.removeRoom,
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Do you have pets?'),
              value: _hasPet,
              onChanged: widget.petOptionAvailable
                  ? (value) {
                setState(() {
                  _hasPet = value ?? false;
                });
              }
                  : null,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First name',
                hintText: 'Enter first name here',
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last name',
                hintText: 'Enter last name here',
              ),
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'MM/DD/YYYY',
                suffixIcon: IconButton(
                  onPressed: () {
                  _selectDate(context);
                  },
                  icon: Icon(Icons.calendar_month),
                    )
              ),
              // keyboardType: TextInputType.datetime,
            ),
            CheckboxListTile(
              title: Text('Child'),
              value: _isChild,
              onChanged: (value) {
                setState(() {
                  _isChild = value ?? false;
                });
              },
            ),
            ElevatedButton.icon(
              onPressed: _addMember,
              icon: Icon(Icons.add),
              label: Text('Add Member'),
            ),
            ...widget.room.members.map((member) {
              return ListTile(
                title: Text('${member.firstName} ${member.lastName}'),
                subtitle: Text('DOB: ${member.dateOfBirth} ${member.isChild ? '(Child)' : ''}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => widget.removeMember(member),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2070),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Update the TextField with the selected date
      });
    }
  }

}

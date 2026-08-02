import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/widgets/group_card.dart';

class GroupsCardScreen extends StatefulWidget {
  const GroupsCardScreen({super.key});

  @override
  State<GroupsCardScreen> createState() => _GroupsCardScreenState();
}

class _GroupsCardScreenState extends State<GroupsCardScreen> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIs.getAllGroups(),

      builder: (context, snapshot) {
        // --------------------- Loading State ---------------------
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // --------------------- No Data State ---------------------
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No Groups Found!',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          );
        }

        // --------------------- Data State ---------------------
        final groupsList = snapshot.data ?? [];

        if (groupsList.isNotEmpty) {
          return ListView.builder(
            itemCount: groupsList.length,
            padding: EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              // final group = groupsList[index];
              // return ListTile(
              //   title: Text(group.groupName, style: TextStyle(color: Colors.white)),
              //   subtitle: Text('Admin: ${group.admin}', style: TextStyle(color: Colors.white)),
              // );

              return GroupCard(group: groupsList[index]);
            },
          );
        } else {
          return Center(
            child: Text(
              'No Connections Found!',
              style: TextStyle(fontSize: 22),
            ),
          );
        }

        // --------------------- Old Scaffold Example ---------------------
        // return Scaffold(
        //   backgroundColor: const Color.fromARGB(255, 0, 12, 1),
        //   body: ListView.builder(
        //     // itemCount: groupsList.length,
        //     // padding: EdgeInsets.only(top: 8),
        //     // itemBuilder: (context, index) {
        //     //   final group = groupsList[index];
        //     //   return ListTile(
        //     //     title: Text(group.groupName, style: TextStyle(color: Colors.white),),
        //     //     subtitle: Text('Admin: ${group.admin}', style: TextStyle(color: Colors.white),),
        //     //   );
        //     itemCount: 1,
        //     itemBuilder: (context, index) {
        //       return GroupCard();
        //     },
        //   ),
        // );
      },
    );
  }
}

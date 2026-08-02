// --------------------- Imports ---------------------
import 'package:flutter/material.dart';

class EditableProfile extends StatefulWidget {
  const EditableProfile({super.key});

  @override
  State<EditableProfile> createState() => _EditableProfileState();
}

class _EditableProfileState extends State<EditableProfile> {
  bool _editing = false; // whether user is editing right now

  final _nameCtrl = TextEditingController(text: "John Doe");
  final _aboutCtrl = TextEditingController(text: "Just living my best Flutter life 🩵");

  // --------------------- Simulated Save ---------------------
  void _saveChanges() {
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.close : Icons.edit),
            onPressed: () => setState(() => _editing = !_editing),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------- Name ---------------------
            const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            _editing
                ? TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your name",
                    ),
                  )
                : Text(
                    _nameCtrl.text,
                    style: const TextStyle(fontSize: 18),
                  ),

            const SizedBox(height: 20),

            // --------------------- About ---------------------
            const Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            _editing
                ? TextField(
                    controller: _aboutCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write something about yourself",
                    ),
                  )
                : Text(
                    _aboutCtrl.text,
                    style: const TextStyle(fontSize: 16),
                  ),

            const SizedBox(height: 30),

            // --------------------- Save Button ---------------------
            if (_editing)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

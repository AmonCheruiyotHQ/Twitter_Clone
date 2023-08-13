import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/providers/user_providoer.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery, requestFullMetadata: false);
              if (pickedImage != null) {
                ref
                    .read(userProvider.notifier)
                    .updateImage(File(pickedImage.path));
              }
            },
            child: CircleAvatar(
              radius: 100,
              foregroundImage: NetworkImage(currentUser.user.profilePicture),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text("Tap Image toChange"),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Enter Your Name"),
            controller: _nameController,
          ),
          TextButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .updateName(_nameController.text);
              },
              child: const Text('Update'))
        ]),
      ),
    );
  }
}

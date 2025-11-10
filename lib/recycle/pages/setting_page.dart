import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_app/recycle/common/shared_pref.dart';

class SettingPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const SettingPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool _isDarkMode;
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _addressController = TextEditingController(text: '');
  // image file store garna
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
   // paila save garako feri load garna
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String username = await SharedPrefService.getUsername();
      String address = await SharedPrefService.getAddress();
      String imgPath = await SharedPrefService.getProfileImage();

      setState(() {
        _nameController.text = username;
        _addressController.text = address;
        if (imgPath.isNotEmpty) {
          _profileImage = File(imgPath); // image paila nai xa bhana
        }
      });
    });
  }
  // device bata image lina lai main function
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
      await SharedPrefService.setProfileImage(pickedImage.path); // path permanently save garna
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                ),
                value: _isDarkMode,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() => _isDarkMode = value);
                  widget.onThemeToggle(value);
                },
              ),

              const SizedBox(height: 30),
              Divider(color: textColor, thickness: 1.5),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 60, color: isDark ? Colors.white70 : Colors.grey)
                          : null,
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text("Change Profile Picture"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: textColor),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: _addressController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(color: textColor),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () async {
                        await SharedPrefService.setUsername(_nameController.text);
                        await SharedPrefService.setAddress(_addressController.text);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Settings saved successfully!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

This code is not complete and giving error rn

 */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tour_planner/screens/preferences/preferences_intro_screen.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../services/internet_connectivity.dart';
import '../../services/pfp_services.dart';
import '../../utilities/button/arrow_back_button.dart';

class NewUserDetails extends StatefulWidget {
  const NewUserDetails({super.key});

  @override
  State<NewUserDetails> createState() => _NewUserDetailsState();
}

class _NewUserDetailsState extends State<NewUserDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  DateTime? _dob;

  String? _gender;

  File? _profileImage;

  Future<void> requestStoragePermission() async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      // Permission granted
    } else {
      // Handle permission denied
      openAppSettings(); // optional
    }
  }


  File? _selectedImage;
  late File imageFile;

  Future<void> pickProfileImage() async {
    File? image = await pickImage();
    _profileImage = image;
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> saveProfileImage() async {
    String? imagePath = await saveImage(_selectedImage);

    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }
  }

  Future<void> saveProfileImageOnline() async {
    if (_selectedImage != null) {
      await uploadProfileImageToSupabase(imageFile);
    } else {
      print("No image selected, skipping upload.");
    }
  }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _dob != null &&
        _gender != null &&
        _profileImage != null) {
        bool hasInternet = await getInternetStatus();
        if (!hasInternet) {
          //noInternetAlert(context);
        }
        if (_selectedImage != null) {
          await saveProfileImage();
          await saveProfileImageOnline();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PreferencesIntroScreen()));
        } else {
          String defaultUrl = await fetchDefaultProfileUrl();
        }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(alignment: Alignment.topLeft, child: ArrowBackButton()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Image Picker
              Center(
                child: GestureDetector(
                  onTap: pickProfileImage,
                  child: Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : AssetImage(
                            'assets/images/icons/new_profile_icon.png',
                          ) as ImageProvider,
                        ),
                      ),
                      if (_selectedImage == null)
                        Icon(Icons.add_a_photo),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Enter Username",
                  hintStyle: TextStyle(
                    color: Color(0xFFC4C4C4),
                    fontFamily: "Sofia_Sans",
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F4F4),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Color(0xFFC4C4C4),
                      width: .2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Color(0xFFF4F4F4),
                      width: .2,
                    ),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 20),

              // DOB Picker
              //WhiteDatePicker_button(onPress: onPress, buttonLabel: buttonLabel),
              ListTile(
                title: Text(_dob == null
                    ? "Select Date of Birth"
                    : "DOB: ${_dob!.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDOB,
              ),
              const SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: ["Male", "Female", "Other"]
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) => value == null ? 'Select gender' : null,
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

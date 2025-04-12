import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tour_planner/backend/classes.dart';
import 'package:my_tour_planner/backend/db_methods.dart';
import 'package:my_tour_planner/screens/preferences/preferences_intro_screen.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:my_tour_planner/utilities/image_picker/profile_image_picker.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewUserDetails extends StatefulWidget {
  const NewUserDetails({Key? key}) : super(key: key);

  @override
  State<NewUserDetails> createState() => _NewUserDetailsState();
}

class _NewUserDetailsState extends State<NewUserDetails> {
  String? _imageUrl;
  final SupabaseClient supabase = Supabase.instance.client;
  final profile_db = ProfileDB();

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  DateTime? _selectedDate;
  int? _selectedGenderIndex;

  final List<String> _genderOptions = ['Male', 'Female', 'Others'];

  bool _usernameError = false;
  bool _dobError = false;
  bool _genderError = false;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: ArrowBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ProfileImagePicker(
                imageUrl: _imageUrl,
                onUpload: (imageUrl) async {
                  setState(() {
                    _imageUrl = imageUrl;
                  });
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() => _usernameError = false);
                },
              ),
              if (_usernameError)
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Username is required',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text("Select Date of Birth: ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sofia_Sans',
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5),
                  WhiteDatePicker_button(
                    width: 130,
                    onPress: _pickDate,
                    buttonLabel: Text(
                      _selectedDate == null
                          ? 'Date Of Birth'
                          : DateFormat("d MMM, yyyy").format(_selectedDate!),
                      style: const TextStyle(
                          fontSize: 15, fontFamily: 'Sofia_Sans'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              if (_dobError)
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Date of birth is required',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text("Select Gender: ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sofia_Sans',
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5),
                  ToggleButtons(
                    isSelected: List.generate(
                      _genderOptions.length,
                      (index) => _selectedGenderIndex == index,
                    ),
                    onPressed: (int index) {
                      setState(() {
                        _selectedGenderIndex = index;
                        _genderError = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(5),
                    selectedColor: const Color.fromRGBO(254, 254, 254, 1),
                    fillColor: const Color.fromRGBO(0, 157, 192, 1),
                    color: Colors.black,
                    constraints:
                        const BoxConstraints(minHeight: 46, minWidth: 0),
                    children: _genderOptions
                        .map((gender) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              child: Text(
                                gender,
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: 'Sofia_Sans'),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              if (_genderError)
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Gender selection is required',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: active_button_blue(
                  onPress: () async {
                    setState(() {
                      _usernameError = _usernameController.text.trim().isEmpty;
                      _dobError = _selectedDate == null;
                      _genderError = _selectedGenderIndex == null;
                    });

                    if (!_usernameError && !_dobError && !_genderError) {
                      // Database
                      final userId = supabase.auth.currentUser!.id;
                      final formattedDOB =
                          DateFormat('dd MMM yyyy').format(_selectedDate!);
                      // For storing profile_url
                      // await supabase
                      //     .from('Profile')
                      //     .upsert({'profile_photo_url': _imageUrl}).eq(
                      //         'user_id', userId);

                      final newUser = Profile(
                          user_id: userId,
                          username: _usernameController.text,
                          date_of_birth: formattedDOB,
                          gender: _genderOptions[_selectedGenderIndex!],
                          profile_photo_url: _imageUrl);

                      await profile_db.addNewUser(newUser);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreferencesIntroScreen(),
                        ),
                      );
                    }
                  },
                  buttonLabel: const Text(
                    'Save',
                    style: active_button_text_blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

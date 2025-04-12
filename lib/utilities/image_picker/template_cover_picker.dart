import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TemplateCoverPicker extends StatefulWidget {
  const TemplateCoverPicker({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  @override
  State<TemplateCoverPicker> createState() => _TemplateCoverPickerState();
}

class _TemplateCoverPickerState extends State<TemplateCoverPicker> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? _lastImagePath;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Delete previous image if it exists
    if (_lastImagePath != null) {
      await supabase.storage.from('profiles').remove([_lastImagePath!]);
    }

    final imageExtension = image.path.contains('.')
        ? image.path.split('.').last.toLowerCase()
        : 'jpeg';
    final imageBytes = await image.readAsBytes();
    final userId = supabase.auth.currentUser!.id;
    final fileName = const Uuid().v4();
    final imagePath =
        "$userId/trip_cover_picture/cover_$fileName.$imageExtension";

    await supabase.storage.from("profiles").uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: "image/$imageExtension",
          ),
        );

    String imageUrl = supabase.storage.from("profiles").getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString() // bust cache
    }).toString();

    setState(() {
      _lastImagePath = imagePath;
    });

    widget.onUpload(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: widget.imageUrl != null
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageUrl!),
                          fit: BoxFit.cover),
                      border: Border.all(),
                      //color: Color.fromRGBO(0, 157, 192, .7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Color.fromRGBO(0, 157, 192, .7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Color.fromRGBO(254, 254, 254, 1),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Select a Trip Cover Picture",
            style: TextStyle(
              color: Color.fromRGBO(0, 151, 178, 1),
              fontSize: 14,
              fontFamily: 'Sofia_Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker(
      {super.key, required this.imageUrl, required this.onUpload});

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          return;
        }
        final imageExtension = image.path.contains('.')
            ? image.path.split('.').last.toLowerCase()
            : 'jpeg';
        final imageBytes = await image.readAsBytes();
        final userId = supabase.auth.currentUser!.id;
        final imagePath = "$userId/profile";

        await supabase.storage.from("profiles").uploadBinary(
              imagePath,
              imageBytes,
              fileOptions: FileOptions(
                upsert: true,
                contentType: "image/$imageExtension",
              ),
            );
        String imageUrl =
            supabase.storage.from("profiles").getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();
        onUpload(imageUrl);
      },
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: imageUrl != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      imageUrl!,
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Color.fromRGBO(0, 157, 192, .6),
                    ),
                  ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Select a Profile Picture",
            style: TextStyle(
              color: Color.fromRGBO(0, 151, 178, 1),
              fontSize: 14,
              fontFamily: 'Sofia_Sans',
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

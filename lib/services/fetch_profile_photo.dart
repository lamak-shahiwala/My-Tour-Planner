import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchProfilePhoto extends StatefulWidget {
  const FetchProfilePhoto({super.key, required this.avatarRadius});

  final double avatarRadius;

  @override
  State<FetchProfilePhoto> createState() => _FetchProfilePhotoState();
}

class _FetchProfilePhotoState extends State<FetchProfilePhoto> {

  String? image = "";
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<String?> fetchUserPhotoUrl() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('Profile')
        .select('profile_photo_url')
        .eq('user_id', userId)
        .maybeSingle();

    return data?['profile_photo_url'] as String?;
  }

  void _loadUserPhoto() async {
    final photo = await fetchUserPhotoUrl();
    setState(() {
      image = photo ?? "";
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.avatarRadius,
      backgroundColor: Colors.grey[200],
      backgroundImage: image != null && image!.isNotEmpty
          ? NetworkImage(image!)
          : null,
      child: image == null || image!.isEmpty
          ? Icon(
        Icons.person,
        size: widget.avatarRadius * 0.8,
        color: const Color.fromRGBO(0, 157, 192, .6),
      )
          : null,
    );
  }
}

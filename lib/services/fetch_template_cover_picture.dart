/*

Dead code

 */

/*
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchTemplateCoverPicture extends StatefulWidget {
  const FetchTemplateCoverPicture({super.key, required this.avatarRadius});

  final double avatarRadius;

  @override
  State<FetchTemplateCoverPicture> createState() => _FetchTemplateCoverPictureState();
}

class _FetchTemplateCoverPictureState extends State<FetchTemplateCoverPicture> {

  String? image = "";
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> fetchTripID() async {
    final userID = _supabase.auth.currentUser?.id;
    if (userID == null) return null;

    final data = await _supabase
        .from('Trip')
        .select('trip_id')
        .eq('user_id', userID)
        .maybeSingle();

    return data?['trip_id'] as String?;
  }

  Future<String?> fetchTripCoverPictureUrl() async {
    final tripID = fetchTripID();

    final data = await _supabase
        .from('Trip')
        .select('cover_photo_url')
        .eq('trip_id', tripID)
        .maybeSingle();

    return data?['cover_photo_url'] as String?;
  }

  void _loadUserPhoto() async {
    final photo = await fetchTripCoverPictureUrl();
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
*/
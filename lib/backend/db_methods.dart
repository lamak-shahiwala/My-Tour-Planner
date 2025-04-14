import 'package:my_tour_planner/backend/classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripDatabase {
  final database = Supabase.instance.client.from('Trip');

  // Create
  Future createTrip(Trip newTrip) async {
    await database.upsert(newTrip.toMap());
  }

  // Read
  final stream = Supabase.instance.client.from('Trip').stream(
    primaryKey: ['trip_id'],
  ).map((data) => data.map((tripMap) => Trip.fromMap(tripMap)).toList());

  // Delete
  Future deleteTrip(Trip trip) async {
    await database.delete().eq('trip_id', trip.trip_id!);
  }
}

class GenerateTripDatabase {
  final database = Supabase.instance.client.from('Trip');

  // Create
  Future generateTrip(Generate_Trip newTrip) async {
    await database.upsert(newTrip.toMap());
  }

  // Read
  final stream = Supabase.instance.client.from('Trip').stream(
    primaryKey: ['trip_id'],
  ).map((data) => data.map((tripMap) => Trip.fromMap(tripMap)).toList());

  // Delete
  Future deleteTrip(Generate_Trip trip) async {
    await database.delete().eq('trip_id', trip.trip_id!);
  }
}

class ItineraryDatabase {
  final itinerary = Supabase.instance.client.from('Itinerary');
  final itinerary_details = Supabase.instance.client.from('ItineraryDetails');

  Future<int> addItinerary(Itinerary new_itinerary) async {
    final inserted_data = await itinerary
        .upsert(new_itinerary.toMap())
        .select()
        .limit(1)
        .single();

    return inserted_data['itinerary_id'] as int;
  }

  Future<void> addItineraryDetails(ItineraryDetails new_detail) async {
    await itinerary_details.upsert(new_detail.toMap());
  }
}

class ThingsCarryDB {
  final things_carry = Supabase.instance.client.from('things_to_carry');

  Future<void> addCarryItem(Things_Carry carry_item) async {
    await things_carry.upsert(carry_item.toMap());
  }
}

class ProfileDB {
  final profile_db = Supabase.instance.client.from('Profile');

  Future<void> addNewUser(Profile new_user) async {
    try {
      print("Inserting user: ${new_user.toMap()}");

      await profile_db.upsert(new_user.toMap()).select();
    } catch (e) {
      print("Insert error: $e");
    }
  }
}

class PreferencesDB {
  final preference_db = Supabase.instance.client.from('Preferences');

  Future<void> addPreferences(Preferences new_preferences) async {
    try {
      final response =
          await preference_db.upsert(new_preferences.toMap()).select();
      print("Preferences Added : $response");
    } catch (e) {
      print("Insert/Update Error : $e");
    }
  }
}

import 'package:my_tour_planner/backend/classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripDatabase {
  final database = Supabase.instance.client.from('Trip');

  // Create
  Future createTrip(Trip newTrip) async {
    await database.insert(newTrip.toMap());
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
    await database.insert(newTrip.toMap());
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

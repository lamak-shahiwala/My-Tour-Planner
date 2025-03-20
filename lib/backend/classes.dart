class Trip {
  int? trip_id;
  String trip_name;
  String? start_date;
  String? end_date;
  String city_location;
  String user_id;

  Trip(
      {this.trip_id,
      required this.trip_name,
      required this.city_location,
      this.start_date,
      this.end_date,
      required this.user_id});

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
        trip_id: map['trip_id'] as int,
        trip_name: map['trip_name'] as String,
        city_location: map['city_location'] as String,
        start_date: map['start_date'] as String,
        end_date: map['end_date'] as String,
        user_id: map['user_id'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'trip_name': trip_name,
      'city_location': city_location,
      'start_date': start_date,
      'end_date': end_date,
      'user_id': user_id
    };
  }
}

class Generate_Trip {
  int? trip_id;
  String trip_name;
  String? start_date;
  String? end_date;
  String city_location;
  String trip_type;
  String user_id;

  Generate_Trip(
      {this.trip_id,
      required this.trip_name,
      required this.city_location,
      this.start_date,
      this.end_date,
      required this.trip_type,
      required this.user_id});

  factory Generate_Trip.fromMap(Map<String, dynamic> map) {
    return Generate_Trip(
      trip_id: map['trip_id'] as int,
      trip_name: map['trip_name'] as String,
      city_location: map['city_location'] as String,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      trip_type: map['trip_type'] as String,
      user_id: map['user_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trip_name': trip_name,
      'city_location': city_location,
      'start_date': start_date,
      'end_date': end_date,
      'trip_type': trip_type,
      'user_id': user_id,
    };
  }
}

class Itinerary {
  int? itinerary_id;
  int? trip_id;
  String? itinerary_date;

  Itinerary({
    this.itinerary_id,
    this.trip_id,
    this.itinerary_date,
  });

  factory Itinerary.fromMap(Map<String, dynamic> map) {
    return Itinerary(
      itinerary_id: map['itinerary_id'] as int,
      trip_id: map['trip_id'] as int,
      itinerary_date: map['itinerary_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itinerary_id': itinerary_id,
      'trip_id': trip_id,
      'itinerary_date': itinerary_date,
    };
  }
}

class Itinerary_details {
  int? details_id;
  String? details_name;
  String? custom_notes;
  String? preferred_time;
  int? itinerary_id;

  Itinerary_details({
    this.itinerary_id,
    this.details_id,
    required this.details_name,
    required this.custom_notes,
    required this.preferred_time,
  });

  factory Itinerary_details.fromMap(Map<String, dynamic> map) {
    return Itinerary_details(
      itinerary_id: map['itinerary_id'] as int,
      details_id: map['details_id'] as int,
      details_name: map['details_name'] as String,
      custom_notes: map['custom_notes'] as String,
      preferred_time: map['preferred_time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itinerary_id': itinerary_id,
      'details_id': details_id,
      'details_name': details_name,
      'custom_notes': custom_notes,
      'preferred_time': preferred_time,
    };
  }
}

class Things_Carry {
  int? things_carry_id;
  int? trip_id;
  List carry_item = [];

  Things_Carry({
    this.things_carry_id,
    this.trip_id,
    required this.carry_item,
  });

  factory Things_Carry.fromMap(Map<String, dynamic> map) {
    return Things_Carry(
      things_carry_id: map['things_carry_id'] as int,
      trip_id: map['trip_id'] as int,
      carry_item: map['carry_item'] as List,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'things_carry_id': things_carry_id,
      'trip_id': trip_id,
      'carry_item': carry_item,
    };
  }
}

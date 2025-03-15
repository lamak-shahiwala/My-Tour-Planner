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
      user_id : map['user_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trip_name': trip_name,
      'city_location': city_location,
      'start_date': start_date,
      'end_date': end_date,
      'trip_type': trip_type,
      'user_id' : user_id,
    };
  }
}

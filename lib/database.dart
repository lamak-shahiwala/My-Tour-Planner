import 'package:postgres/postgres.dart';

class DatabaseService {
  late PostgreSQLConnection connection;

  Future<void> connect() async {
    connection = PostgreSQLConnection(
      "localhost", // Change to your server if needed
      5432,        // Default PostgreSQL port
      "your_database",
      username: "your_username",
      password: "your_password",
    );

    try {
      await connection.open();
      print("✅ Connected to PostgreSQL!");
    } catch (e) {
      print("❌ Connection error: $e");
    }
  }
}

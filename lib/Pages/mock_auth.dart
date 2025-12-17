import 'dart:convert';
import 'package:flutter/services.dart';

// Mock User class to replace Firebase User
class MockUser {
  final String uid;
  final String? email;
  final String? username;

  MockUser({
    required this.uid,
    this.email,
    this.username,
  });
}

// Mock authentication service
class MockAuth {
  static MockUser? _currentUser;

  static MockUser? get currentUser => _currentUser;

  // Load users from JSON file
  static Future<List<Map<String, dynamic>>> _loadUsers() async {
    try {
      final String jsonString =
          await rootBundle.loadString("Assests/files/users.json");
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(jsonData["users"]);
    } catch (e) {
      print("Error loading users.json: $e");
      return [];
    }
  }

  // Mock sign in with username and password (supports all users dynamically)
  static Future<Map<String, dynamic>> signInWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    try {
      final users = await _loadUsers();

      // Find user with matching username or email and password (supports all users)
      try {
        final user = users.firstWhere(
          (u) =>
              (u["username"].toString().toLowerCase() ==
                      username.toString().toLowerCase() ||
                  u["email"].toString().toLowerCase() ==
                      username.toString().toLowerCase()) &&
              u["password"].toString() == password.toString(),
        );

        _currentUser = MockUser(
          uid: user["uid"],
          email: user["email"],
          username: user["username"],
        );
        return {
          "success": true,
          "user": _currentUser,
        };
      } catch (e) {
        // User not found
        return {
          "success": false,
          "error": "Invalid username or password",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": "Error loading users: $e",
      };
    }
  }

  // Keep old method name for compatibility (now uses username)
  static Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return signInWithUsernameAndPassword(username: email, password: password);
  }

  // Mock create user with email and password
  static Future<Map<String, dynamic>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final users = await _loadUsers();

    // Check if user already exists
    final existingUser = users.any((u) => u["email"] == email);

    if (existingUser) {
      return {
        "success": false,
        "error": "User already exists",
      };
    }

    // Create new user
    final newUid = "mock_user_${users.length + 1}";
    final username = email.split("@")[0]; // Extract username from email

    _currentUser = MockUser(
      uid: newUid,
      email: email,
      username: username,
    );

    return {
      "success": true,
      "user": _currentUser,
    };
  }

  // Sign out
  static Future<void> signOut() async {
    _currentUser = null;
  }
}

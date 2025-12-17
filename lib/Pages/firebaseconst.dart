// COMMENTED OUT: Firebase imports - using mock authentication instead
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// COMMENTED OUT: Firebase authentication - using mock instead
// FirebaseAuth auth = FirebaseAuth.instance;
// FirebaseFirestore firestore = FirebaseFirestore.instance;
// User? currentUser = auth.currentUser;

// MOCK: Using mock authentication service
import 'mock_auth.dart';

// Get current user from mock auth (updates automatically)
MockUser? get currentUser => MockAuth.currentUser;

const userCollections = "users";

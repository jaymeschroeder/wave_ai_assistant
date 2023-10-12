import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> addUserToFirestore(User user) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users');

    try {
      await userRef.doc(user.uid).set({
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        // Add more user information as needed
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  static Future<void> addStripeCustomerId(String userId, String stripeCustomerId) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(userId);

    try {
      await userRef.set({
        'stripe_customer_id': stripeCustomerId,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding stripe_customer_id: $e');
    }
  }

  static Future<String?> getStripeCustomerId(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(userId);

    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final stripeCustomerId = userData['stripe_customer_id'];
        return stripeCustomerId;
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      print('Error getting stripe_customer_id: $e');
      return null;
    }
  }

  static Future<String?> getUserName(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(userId);

    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userName = userData['displayName']; // Assuming 'displayName' is the field for the user's name
        return userName;
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  static Future<String?> getUserEmail(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(userId);

    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userEmail = userData['email']; // Assuming 'email' is the field for the user's email
        return userEmail;
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      print('Error getting user email: $e');
      return null;
    }
  }
}

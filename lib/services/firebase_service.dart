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

  static Future<void> updateAnonymousUser(String previousUid, String newUid) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users');

    try {
      // Get the data from the previous UID
      if (previousUid.isNotEmpty) {
        DocumentSnapshot previousUserDoc = await userRef.doc(previousUid).get();
        print("FIREBASE: Previous uid is not empty");
        if (previousUserDoc.exists) {
          print("FIREBASE: Previous user doc exists");
          Map<String, dynamic> userData = previousUserDoc.data() as Map<String, dynamic>;
          String email = userData['email'];
          String displayName = userData['displayName'];
          String stripeCustomerId = userData['stripe_customer_id'];

          // Set the data with the new UID
          await userRef.doc(newUid).set({
            'uid': newUid,
            'email': email,
            'displayName': displayName,
            'stripe_customer_id': stripeCustomerId,
          });

          try{
            // Delete the previous UID data
            print("FIREBASE: Deleting doc $previousUid");
            await userRef.doc(previousUid).delete();

          } catch (e){
            print("FIREBASE ERROR: $e");
          }

        } else {
          // Set the data with the new UID
          await userRef.doc(newUid).set({
            'uid': newUid,
            'email': 'anon',
            'displayName': 'anon',
            'stripe_customer_id': '',
          });
        }
      } else {
        // Set the data with the new UID
        await userRef.doc(newUid).set({
          'uid': newUid,
          'email': 'anon',
          'displayName': 'anon',
          'stripe_customer_id': '',
        });
      }
    } catch (e) {
      print('Error updating user data: $e');
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

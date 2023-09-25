import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String BASE_URL = "https://api.openai.com/v1";
String AD_UNIT_ID = "ca-app-pub-8432151320279223/1091800447";
//String DEVICE_ID_S9 = "de27104a66a5101d";
String DEVICE_ID_S9 = "49EBF358B00803A1CC708B60CB474AF6";

final LinearGradient APP_GRADIENT = LinearGradient(
  begin: Alignment.topLeft, // Define the gradient's start and end points
  end: Alignment.bottomRight,
  colors: [
    Colors.purple.withOpacity(0.2),
    Colors.blue.withOpacity(0.3),
    Colors.purpleAccent.withOpacity(0.1)
  ], // Define your gradient colors
);

Color primaryColor = Color(0xFF00A8E8);

const String PRIVACY_POLICY =
    "Thank you for choosing RV TechLink, a mobile application connecting RV technicians with customers looking to have repairs done. We are committed to protecting your privacy, and this Privacy Policy outlines how we collect, use, and share information collected from users of the RV TechLink mobile application.\n\n"
    "By using our RV TechLink application, you agree to the collection and use of information in accordance with this policy. If you do not agree to the terms of this Privacy Policy, please do not use the RV TechLink application.\n\n"
    "1. Information We Collect\n"
    "We collect the following types of information from our users:\n"
    "1.1 Personal Information When you create an account with RV TechLink, we collect personal information that includes your name, email, phone number, profile image (optional), and user identification, which is required for account creation, including 1 piece of government issued ID and certification for RV technicians. We collect this information to identify you and facilitate matches with other users.\n\n"
    "1.2 RV TechLink collects location data to facilitate connections between RV technicians and customers in need of repairs. For RV technicians, background location data is collected during the travel portion of the job request sequence, but at all other times during use of the app, it is only updated in the foreground. By using RV TechLink, you consent to the collection and use of location data in accordance with this policy. You can disable the collection of location data by disabling location services for the RV TechLink application in your mobile device settings.\n\n"
    "Please note that disabling location services may limit the functionality of the RV TechLink application, including the ability to match RV technicians with nearby repair requests.\n\n"
    "1.3 Payment Information When you use RV TechLink to process payments, we collect payment information through the Stripe API, which may include your credit card information, billing address, and other relevant financial information. We collect this information to process payments for services provided by RV technicians.\n\n"
    "1.4 Log Data When you use the RV TechLink application, we automatically collect certain information that your mobile device sends to us, including your device's Internet Protocol (IP) address, browser type, and version, as well as information about how you interact with our application.\n\n"
    "2. Use of Information\n"
    "We use the information we collect for the following purposes:\n"
    "2.1 To facilitate connections between RV technicians and customers looking for repairs.\n\n"
    "2.2 To process payments for services provided by RV technicians.\n\n"
    "2.3 To provide customer support and respond to user inquiries.\n\n"
    "2.4 To monitor and analyze usage trends and improve the functionality of the RV TechLink application.\n\n"
    "3. Sharing of Information\n"
    "We do not sell or rent your personal information to third parties. We may share your information in the following circumstances:\n"
    "3.1 With other users of the RV TechLink application in order to facilitate connections between RV technicians and customers.\n\n"
    "3.2 With our third-party service providers who assist us in providing the RV TechLink application and related services, including payment processing.\n\n"
    "3.3 When required by law, such as in response to a subpoena or other legal process.\n\n"
    "4. Security\n"
    "We take reasonable steps to protect the information we collect from our users from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the Internet or method of electronic storage is 100% secure, and we cannot guarantee the absolute security of your information.\n"
    "5. Data Retention We will retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.\n\n"
    "6. Changes to This Policy We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.\n\n"
    "7. Contact Us If you have any questions about this Privacy Policy, please contact us at info@rv-link.ca.\n\n";

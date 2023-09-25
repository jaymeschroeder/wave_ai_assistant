import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

// TODO The following comment block describes how to send and receive a message from chatgpt
/*
                // Create a conversation with a system message
                final conversation = [
                  {"role": "system", "content": "You are Peter Griffin from Family Guy."},
                ];

                // Send the system message to set the context
                String system = await chatGPTProvider.sendMessage(json.encode(conversation));

                String response = await ChatGPTService.sendMessage("tell me a joke about your family.");
                print(response);
                */

class ChatGPTService {
  static final List<Map<String, String>> _conversationHistory = [];
  static bool _isNewConversation = true;

  static Future<String> sendMessage(String message) async {
    if (_isNewConversation) {
      // If it's a new conversation, add a system message to set context
      _conversationHistory.add({
        "role": "system",
        "content": "This conversation is powered by Wave AI.",
      });
      _isNewConversation = false;
    }

    // Add the user message to the conversation history
    _conversationHistory.add({"role": "user", "content": message});

    var res = await http.post(
      Uri.parse("$BASE_URL/chat/completions"),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": _conversationHistory,
        "temperature": 0.8,
      }),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      String reply = data['choices'][0]['message']['content'].toString();

      // Check if the response is too short or contains certain keywords
      if (reply.trim().isEmpty || reply.contains("I don't understand")) {
        reply = "I couldn't quite understand your question.";
      } else {
        // Replace "OpenAI" with "Wave AI" in the response
        reply = reply.replaceAll("OpenAI", "Wave AI");
      }

      // Add the assistant reply to the conversation history
      _conversationHistory.add({"role": "assistant", "content": reply});

      return reply;
    } else {
      throw Exception('Failed to send message: ${res.statusCode}');
    }
  }

  static void startNewConversation() {
    _conversationHistory.clear();
    _isNewConversation = true;
  }
}

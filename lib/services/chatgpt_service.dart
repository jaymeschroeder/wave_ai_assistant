import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wave_ai_assistant/constants/api_keys.dart';
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
  static final List<Map<String, String>> assistantHistory = [];
  static bool _isNewAssistantConversation = true;

  static Future<String> sendMessage(String message) async {
    if (_isNewAssistantConversation) {
      // If it's a new conversation, add a system message to set context
      assistantHistory.add({
        "role": "system",
        "content": "This conversation is powered by Wave AI.",
      });
      _isNewAssistantConversation = false;
    }

    // Add the user message to the conversation history
    assistantHistory.add({"role": "user", "content": message});

    var res = await http.post(
      Uri.parse("$BASE_URL/chat/completions"),
      headers: {
        'Authorization': 'Bearer $OPENAI_API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": assistantHistory,
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
        reply = reply.replaceAll("ChatGPT", "Wave Assistant");
      }

      // Add the assistant reply to the conversation history
      assistantHistory.add({"role": "assistant", "content": reply});

      return reply;
    } else {
      throw Exception('Failed to send message: ${res.statusCode}');
    }
  }

  static Future<String> translateMessage(String message, String toLanguage) async {
    String completeMessage =
        "translate the following text to $toLanguage. Do not write any additional words before or after the translated text:\n\n$message";

    var res = await http.post(
      Uri.parse("$BASE_URL/chat/completions"),
      headers: {
        'Authorization': 'Bearer $OPENAI_API_KEY',
        'Content-Type': 'application/json; charset=utf-8', // Set the charset to utf-8
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a translator and you do not provide any other information than responding with the translation."},
          {"role": "user", "content": completeMessage},
        ],
        "temperature": 0.6,
      }),
      encoding: Encoding.getByName('utf-8'), // Set the encoding explicitly
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      String reply = data['choices'][0]['message']['content'].toString();

      return reply;
    } else {
      throw Exception('Failed to send message: ${res.statusCode}');
    }
  }

  static void resetAssistant() {
    assistantHistory.clear();
    _isNewAssistantConversation = true;
  }
}

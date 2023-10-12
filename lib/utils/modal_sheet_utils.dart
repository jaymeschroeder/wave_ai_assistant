import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../services/chatgpt_service.dart';
import '../widgets/frosted_glass_background.dart';

class ModalSheetUtils {
  static showChatLogSheet(BuildContext context) async {
    showCupertinoModalBottomSheet(
      duration: const Duration(milliseconds: 250),
      animationCurve: Curves.ease,
      context: context,
      builder: (context) => FrostedGlassBackground(
        child: Material(
          color: Colors.white.withOpacity(0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            color: Colors.black.withOpacity(0.825),
            child: Column(
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, // Define the gradient's start and end points
                      end: Alignment.bottomRight,
                      colors: [

                        Colors.black.withOpacity(0.1),
                        Colors.blue.withOpacity(0.6),
                      ], // Define your gradient colors
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Log',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                        shadows: [
                          Shadow(
                              offset: Offset(-2, -2), // Adjust the shadow offset as needed
                              color: Colors.black,
                              blurRadius: 14 // Shadow color
                              ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ChatGPTService.assistantHistory.length,
                    itemBuilder: (context, index) {
                      final message = ChatGPTService.assistantHistory[index];

                      // Assuming your Map has 'sender' and 'text' keys
                      final sender = message['role'];
                      final text = message['content'];

                      if (sender == "system") return Container();
                      return Align(
                        alignment: (sender == "assistant") ? Alignment.centerLeft : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          // Adjust the horizontal padding as needed
                          child: Row(
                            mainAxisAlignment:
                                (sender == "assistant") ? MainAxisAlignment.start : MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment:
                                      (sender == "assistant") ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      sender!,
                                      style: const TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    IntrinsicWidth(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (sender == "assistant")
                                              ? Colors.blue.withOpacity(0.4)
                                              : Colors.green.withOpacity(0.75),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        constraints: BoxConstraints(
                                          // You can adjust the maximum width as needed or remove maxWidth altogether
                                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                                        ),
                                        child: SelectableText(
                                          text!,
                                          textAlign: (sender == "assistant") ? TextAlign.start : TextAlign.end,
                                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                                          contextMenuBuilder: (context, editableTextState) {
                                            final List<ContextMenuButtonItem> buttonItems =
                                                editableTextState.contextMenuButtonItems;
                                            buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
                                              return buttonItem.type == ContextMenuButtonType.cut;
                                            });
                                            return AdaptiveTextSelectionToolbar.buttonItems(
                                              anchors: editableTextState.contextMenuAnchors,
                                              buttonItems: buttonItems,
                                            );
                                          },
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

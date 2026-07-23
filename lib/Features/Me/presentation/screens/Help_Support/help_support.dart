import 'package:flutter/material.dart';
import '../../../../../components/AppText/appText.dart';
import '../../../../../components/CustomButton/custom_button.dart';
import '../../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../../components/RoundBackButton.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8FBF0),
              Color(0xFFF4FDF9),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Header
                      Row(
                        children: [
                          RoundBackButton(
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const AppText(
                            "Help & Support",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0F172A),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),

                      const SizedBox(height: 28),

                      /// Subject
                      CustomTextField(
                        controller: _titleController,
                        hintText: "Tell us your problem...",
                        filColor: Colors.white,
                        enabled: !isLoading,
                        borderColor: const Color(0xffE2E8F0),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Subject is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),


                      CustomTextField(
                        controller: _messageController,
                        hintText: "e.g. My app is not working...",
                        filColor: Colors.white,
                        enabled: !isLoading,
                        maxLines: 10,
                        borderColor: const Color(0xffE2E8F0),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please describe your issue";
                          }
                          return null;
                        },
                      ),
                      /// Description
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(
                      //       color: const Color(0xffE2E8F0),
                      //     ),
                      //   ),
                      //   child: TextFormField(
                      //     controller: _messageController,
                      //     enabled: !isLoading,
                      //     maxLines: 10,
                      //     decoration: const InputDecoration(
                      //       hintText: "e.g. My app is not working...",
                      //       hintStyle: TextStyle(
                      //         color: Color(0xff8A8A8A),
                      //         fontSize: 16,
                      //       ),
                      //       border: InputBorder.none,
                      //       contentPadding: EdgeInsets.all(18),
                      //     ),
                      //     validator: (value) {
                      //       if (value == null || value.trim().isEmpty) {
                      //         return "Please describe your issue";
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),

                      const Spacer(),

                      /// Button
                      CustomButton(
                        text: isLoading ? "Sending..." : "Send",
                        suffix: Transform.rotate(
                            angle: 180 * 3.1416 / 10,
                            child: const Icon(Icons.send_time_extension_outlined, color: Colors.white, size: 20)),
                        onTap: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            // Send API
                          }
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
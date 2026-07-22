import 'package:flutter/material.dart';

class AnalysisDataScreen extends StatelessWidget {
  const AnalysisDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Background Decorative Ellipse (Top Right)
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                width: 200,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // --- CUSTOM APP BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        _buildRoundBackButton(
                          onTap: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(right: 44.0), // Offsets the back button to keep title centered
                              child: Text(
                                "Analysis Data",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- MAIN SCREEN BODY ---
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 3D Magnifying Glass Illustration
                          Image.asset("assets/images/search.png",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF08A).withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search,
                                size: 100,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Progress Percentage Text
                          const Text(
                            "20% Complete",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Progress Status Checklists
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Completed state
                              _buildProgressStep(
                                label: "Fetching product data",
                                state: StepState.completed,
                              ),
                              const SizedBox(height: 16),

                              // 2. In-progress state
                              _buildProgressStep(
                                label: "Checking legitimacy signals",
                                state: StepState.inProgress,
                              ),
                              const SizedBox(height: 16),

                              // 3. Pending/Inactive states
                              _buildProgressStep(
                                label: "Analysing supplier info",
                                state: StepState.pending,
                              ),
                              const SizedBox(height: 16),

                              _buildProgressStep(
                                label: "Calculating trust score",
                                state: StepState.pending,
                              ),
                              const SizedBox(height: 16),

                              _buildProgressStep(
                                label: "Building final report",
                                state: StepState.pending,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rounded Back Button UI Widget
  Widget _buildRoundBackButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF1E293B),
          size: 18,
        ),
      ),
    );
  }

  // Progress Step List Item UI Widget
  Widget _buildProgressStep({required String label, required StepState state}) {
    Widget icon;
    TextStyle textStyle;

    switch (state) {
      case StepState.completed:
        icon = const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF10B981), // Solid Vibrant Green
          size: 22,
        );
        textStyle = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B), // Dark text
        );
        break;

      case StepState.inProgress:
        icon = const Icon(
          Icons.sync_rounded, // Replace with custom rotating/processing SVG if desired
          color: Color(0xFFF59E0B), // Warm Orange
          size: 22,
        );
        textStyle = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Slightly bolder for active step
          color: Color(0xFF1E293B),
        );
        break;

      case StepState.pending:
      default:
        icon = const Icon(
          Icons.radio_button_checked,
          color: Color(0xFF94A3B8),
          size: 22,
        );
        textStyle = const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Color(0xFF94A3B8),
        );
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Text(
          label,
          style: textStyle,
        ),
      ],
    );
  }
}

// Step Status Enum
enum StepState {
  completed,
  inProgress,
  pending,
}
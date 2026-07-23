import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_colour.dart';
import '../../../../components/RoundBackButton.dart';
import '../../Home/data/repositories/product_repository.dart';
import '../../ProductDetails/data/models/product_Analysis_models.dart';
import '../../ProductDetails/providers/prodcut_providers.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_exceptions.dart';
import '../../auth/presentation/providers/login_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/core/constants/app_constants.dart';
import '../../Me/presentation/providers/profile_provider.dart';

class AnalysisDataScreen extends ConsumerStatefulWidget {
  final String? url;
  final String? imagePath;
  const AnalysisDataScreen({super.key, this.url, this.imagePath});

  @override
  ConsumerState<AnalysisDataScreen> createState() => _AnalysisDataScreenState();
}

class _AnalysisDataScreenState extends ConsumerState<AnalysisDataScreen> {
  int _progress = 0;
  Timer? _timer;
  bool _hasError = false;
  String _errorMessage = '';

  StepState _fetchingState = StepState.pending;
  StepState _checkingState = StepState.pending;
  StepState _analysingState = StepState.pending;
  StepState _calculatingState = StepState.pending;
  StepState _buildingState = StepState.pending;

  @override
  void initState() {
    super.initState();
    if ((widget.url != null && widget.url!.isNotEmpty) || (widget.imagePath != null && widget.imagePath!.isNotEmpty)) {
      _startAnalysisJob();
    } else {
      _hasError = true;
      _errorMessage = 'No URL or Image provided for analysis.';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnalysisJob() {
    final repository = ProductRepository(ref.read(apiClientProvider));


    // Set first step in progress
    setState(() {
      _fetchingState = StepState.inProgress;
    });

    final Future<AnalysisStartResponse> analysisFuture = (widget.imagePath != null && widget.imagePath!.isNotEmpty)
        ? repository.AnalyzeImage(widget.imagePath!)
        : repository.Analysis(widget.url!);

    // 1. Start analysis
    analysisFuture.then((startResponse) {
      if (!mounted) return;

      // 2. Start polling based on the returned jobId and pollAfterMs
      _pollJobStatus(startResponse.jobId, startResponse.pollAfterMs);
    }).catchError((error) {
      if (mounted) {
        String msg = error.toString();
        if (error is AppException) {
          msg = error.message;
        }
        setState(() {
          _hasError = true;
          _errorMessage = msg;
        });
      }
    });
  }

  void _pollJobStatus(String jobId, int pollIntervalMs) {
    _timer = Timer(Duration(milliseconds: pollIntervalMs), () {
      if (!mounted) return;
      final repository = ProductRepository(ref.read(apiClientProvider));

      repository.getAnalysisJobStatus(jobId).then((job) {
        if (!mounted) return;

        setState(() {
          _progress = job.progress;

          // Map progress directly to UI checklist steps
          if (_progress >= 20) {
            _fetchingState = StepState.completed;
            if (_progress < 40) _checkingState = StepState.inProgress;
          } else {
            _fetchingState = StepState.inProgress;
          }

          if (_progress >= 40) {
            _checkingState = StepState.completed;
            if (_progress < 60) _analysingState = StepState.inProgress;
          }

          if (_progress >= 60) {
            _analysingState = StepState.completed;
            if (_progress < 80) _calculatingState = StepState.inProgress;
          }

          if (_progress >= 80) {
            _calculatingState = StepState.completed;
            if (_progress < 100) _buildingState = StepState.inProgress;
          }

          // Handle complete / error states
          if (job.status.toLowerCase() == 'completed' || _progress >= 100) {
            _fetchingState = StepState.completed;
            _checkingState = StepState.completed;
            _analysingState = StepState.completed;
            _calculatingState = StepState.completed;
            _buildingState = StepState.completed;
            _progress = 100;
            _onAnalysisComplete(jobId);
          } else if (job.status.toLowerCase() == 'failed' || job.error != null) {
            _hasError = true;
            _errorMessage = job.error ?? 'Analysis job failed on server.';
          } else {
            // Recursively poll status again after interval
            _pollJobStatus(jobId, pollIntervalMs);
          }
        });
      }).catchError((error) {
        if (mounted) {
          String msg = error.toString();
          if (error is AppException) {
            msg = error.message;
          }
          setState(() {
            _hasError = true;
            _errorMessage = msg;
          });
        }
      });
    });
  }

  void _onAnalysisComplete(String jobId) {
    final repository = ProductRepository(ref.read(apiClientProvider));
    
    repository.getAnalysisJobResult(jobId).then((scannedProduct) {
      if (!mounted) return;

      // Refresh the products list to include the newly analyzed product
      ref.read(productsProvider.notifier).refresh().then((_) {
        // Invalidate profileFutureProvider to update capacity counts
        ref.invalidate(profileFutureProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Analysis completed successfully!'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          
          context.pushReplacement(
            AppPaths.product_details,
            extra: scannedProduct,
          );
        }
      });
    }).catchError((error) {
      if (mounted) {
        String msg = error.toString();
        if (error is AppException) {
          msg = error.message;
        }
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to fetch analysis result: $msg';
        });
      }
    });
  }

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
                        RoundBackButton(
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
                          if (_hasError) ...[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.search_off_rounded,
                                        size: 60,
                                        color: Colors.redAccent,
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    const Text(
                                      "Product Not Found",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Text(
                                      "We couldn't analyze this product.\n"
                                          "Please check the product URL or try another one.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.arrow_back_rounded),
                                        label: const Text(
                                          "Try Another Product",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            // 3D Magnifying Glass Illustration
                            Image.asset(
                              "assets/images/search.png",
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
                            Text(
                              "$_progress% Complete",
                              style: const TextStyle(
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
                                _buildProgressStep(
                                  label: "Fetching product data",
                                  state: _fetchingState,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressStep(
                                  label: "Checking legitimacy signals",
                                  state: _checkingState,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressStep(
                                  label: "Analysing supplier info",
                                  state: _analysingState,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressStep(
                                  label: "Calculating trust score",
                                  state: _calculatingState,
                                ),
                                const SizedBox(height: 16),
                                _buildProgressStep(
                                  label: "Building final report",
                                  state: _buildingState,
                                ),
                              ],
                            ),
                          ],
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

class AnalysisStartResponse {
  final String jobId;
  final String status;
  final int pollAfterMs;

  AnalysisStartResponse({
    required this.jobId,
    required this.status,
    required this.pollAfterMs,
  });

  factory AnalysisStartResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['response']?['data'] ?? json['data'] ?? json) as Map<String, dynamic>;
    return AnalysisStartResponse(
      jobId: data['jobId']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      pollAfterMs: data['pollAfterMs'] as int? ?? 2000,
    );
  }
}

class AnalysisJobResponse {
  final String id;
  final String status;
  final int progress;
  final String? step;
  final String? scanId;
  final String? error;

  AnalysisJobResponse({
    required this.id,
    required this.status,
    required this.progress,
    this.step,
    this.scanId,
    this.error,
  });

  factory AnalysisJobResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['response']?['data'] ?? json['data'] ?? json) as Map<String, dynamic>;
    return AnalysisJobResponse(
      id: data['id']?.toString() ?? data['jobId']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      progress: (data['progress'] as num?)?.toInt() ?? 0,
      step: data['step']?.toString(),
      scanId: data['scanId']?.toString(),
      error: data['error']?.toString(),
    );
  }
}
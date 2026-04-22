class ApiEndPoints {
  ApiEndPoints._privateConstructor();
  static final ApiEndPoints instance = ApiEndPoints._privateConstructor();
  static const bool isLive = true;
  static const String baseUrl = isLive
      ? "https://api.voiceink.ai/api/"
      : "https://api.voiceink.ai/api/";

  // Auth
  static const String login = "${baseUrl}v1/auth/email/login";
  static const String regiserLogin = "${baseUrl}v1/auth/email/register-and-login";
  static const String forgotPassword = "${baseUrl}v1/auth/forgot/password";
  static const String resetPassword = "${baseUrl}v1/auth/reset/password";

  // Files endpoints
  static const String audioFiles = "${baseUrl}v1/audio-files";

  // Transcript Detail endpoints
  static String audioFileDetail(String fileId) => "${baseUrl}v1/audio-files/$fileId";
  static String fileStreamUrl(String fileId) => "${baseUrl}v1/files/$fileId/stream-url";
  static String transcriptionResults(String fileId) => "${baseUrl}v1/transcription-results/file/$fileId";
  static String updateTranscriptionWord(String resultId) => "${baseUrl}v1/transcription-results/$resultId/words";
}
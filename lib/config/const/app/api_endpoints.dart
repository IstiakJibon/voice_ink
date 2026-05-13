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
  static String audioFileFavorite(String fileId) =>
      "${baseUrl}v1/audio-files/$fileId/favorite";

  // Transcript Detail endpoints
  static String audioFileDetail(String fileId) => "${baseUrl}v1/audio-files/$fileId";
  static String fileStreamUrl(String fileId) => "${baseUrl}v1/files/$fileId/stream-url";
  static String transcriptionResults(String fileId) => "${baseUrl}v1/transcription-results/file/$fileId";
  static String updateTranscriptionWord(String resultId) => "${baseUrl}v1/transcription-results/$resultId/words";

  // Export endpoints
  static String exportInstant(String transcriptionResultId) =>
      "${baseUrl}v1/export/instant/$transcriptionResultId";

  // Re-transcribe endpoints
  static String audioFileTranscribe(String fileId) =>
      "${baseUrl}v1/audio-files/$fileId/transcribe";
  static String audioFileTranscriptionStatus(String fileId) =>
      "${baseUrl}v1/audio-files/$fileId/transcription-status";

  // Single transcription result detail (for switching between results)
  static String transcriptionResultDetail(String resultId) =>
      "${baseUrl}v1/transcription-results/$resultId";

  static String setPrimaryTranscriptionResult(String resultId) =>
      "${baseUrl}v1/transcription-results/$resultId/set-primary";

  // Quota endpoints
  static const String quotaSummary = "${baseUrl}v1/quota/summary";
  static const String quotaAllocations = "${baseUrl}v1/quota/allocations";

  // Folder endpoints
  static const String folders = "${baseUrl}v1/folders";
  static const String foldersTree = "${baseUrl}v1/folders/tree";
  static String folderDetail(String folderId) =>
      "${baseUrl}v1/folders/$folderId";

  // Upload endpoints
  static const String uploadBatchPresignedUrls =
      "${baseUrl}v1/audio-files/upload/batch/presigned-urls";
  static const String uploadBatchComplete =
      "${baseUrl}v1/audio-files/upload/batch/complete";

  // URL import endpoints (YouTube + direct URL)
  static const String audioFilesCheckUrl =
      "${baseUrl}v1/audio-files/check-url";
  static const String audioFilesImportUrl =
      "${baseUrl}v1/audio-files/import/url";

  // Scan / OCR endpoint
  static const String aiExtractText = "${baseUrl}v1/ai/extract-text";

  // Podcast search + episode list (Podcast Index style)
  static const String podcastsSearch = "${baseUrl}v1/podcasts/search";
  static const String podcastsEpisodes = "${baseUrl}v1/podcasts/episodes";
  static const String podcastsDownloadAndImport =
      "${baseUrl}v1/podcasts/download-and-import";
}
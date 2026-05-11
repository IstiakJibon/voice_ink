import 'package:get_it/get_it.dart';
import 'package:voice_ink/config/theme/cubit/theme_cubit.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/features/auth/data/datasources/auth_remote.dart';
import 'package:voice_ink/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voice_ink/features/auth/domain/repositories/auth_repository.dart';
import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/registation/registation_cubit.dart';
import 'package:voice_ink/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:voice_ink/features/files/data/datasources/files_remote.dart';
import 'package:voice_ink/features/files/data/datasources/transcript_detail_remote.dart';
import 'package:voice_ink/features/files/data/repositories/files_repository_impl.dart';
import 'package:voice_ink/features/files/data/repositories/transcript_detail_repository_impl.dart';
import 'package:voice_ink/features/files/domain/repositories/files_repository.dart';
import 'package:voice_ink/features/files/domain/repositories/transcript_detail_repository.dart';
import 'package:voice_ink/features/files/domain/usecases/files_usecase.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/export/export_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/re_transcribe/re_transcribe_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/folder/data/datasources/folder_remote.dart';
import 'package:voice_ink/features/folder/data/repositories/folder_repository_impl.dart';
import 'package:voice_ink/features/folder/domain/repositories/folder_repository.dart';
import 'package:voice_ink/features/folder/domain/usecases/folder_usecase.dart';
import 'package:voice_ink/features/folder/presentation/cubit/folder_cubit.dart';
import 'package:voice_ink/features/quota/data/datasources/quota_remote.dart';
import 'package:voice_ink/features/quota/data/repositories/quota_repository_impl.dart';
import 'package:voice_ink/features/quota/domain/repositories/quota_repository.dart';
import 'package:voice_ink/features/quota/domain/usecases/quota_usecase.dart';
import 'package:voice_ink/features/quota/presentation/cubit/quota_cubit.dart';
import 'package:voice_ink/features/upload/data/datasources/upload_remote.dart';
import 'package:voice_ink/features/upload/data/repositories/upload_repository_impl.dart';
import 'package:voice_ink/features/upload/domain/repositories/upload_repository.dart';
import 'package:voice_ink/features/upload/domain/usecases/upload_usecase.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await _dioClient();
  await _appTheme();
  await _auth();
  await _files();
  await _transcriptDetail();
  await _export();
  await _reTranscribe();
  await _quota();
  await _folder();
  await _upload();
}

Future<void> _appTheme() async {
  sl.registerFactory(() => ThemeCubit());
}

Future<void> _dioClient() async {
  sl.registerFactory(() => DioClient(authCubit: sl()));
}

Future<void> _auth() async {
  // Cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(authUseCase: sl()));
  sl.registerFactory<AuthenticationCubit>(() => AuthenticationCubit());
  sl.registerFactory<RegistrationCubit>(
      () => RegistrationCubit(authUseCase: sl()));
  sl.registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(authUseCase: sl()));
  sl.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(authUseCase: sl()));

  // Auth use-case
  sl.registerLazySingleton(() => AuthUseCase(
        authRepository: sl(),
      ));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteServices: sl()));

  // Data sources
  sl.registerLazySingleton(() => AuthRemoteServices());
}

Future<void> _files() async {
  // Cubits
  sl.registerFactory<FilesCubit>(() => FilesCubit(filesUseCase: sl()));
 
  // Use-case
  sl.registerLazySingleton(() => FilesUseCase(filesRepository: sl()));
 
  // Repository
  sl.registerLazySingleton<FilesRepository>(
      () => FilesRepositoryImpl(filesRemoteServices: sl()));
 
  // Data sources
  sl.registerLazySingleton(() => FilesRemoteServices());
}

Future<void> _transcriptDetail() async {
  // Cubits
  sl.registerFactory<TranscriptDetailCubit>(
    () => TranscriptDetailCubit(
      getFileDetailUseCase: sl(),
      getStreamUrlUseCase: sl(),
      getTranscriptionResultsUseCase: sl(),
      getTranscriptionResultDetailUseCase: sl(),
      deleteTranscriptionResultUseCase: sl(),
      setPrimaryTranscriptionResultUseCase: sl(),
      updateWordTextUseCase: sl(),
      updateWordSpeakerUseCase: sl(),
    ),
  );

  // Use-cases
  sl.registerLazySingleton(
    () => GetFileDetailUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetStreamUrlUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetTranscriptionResultsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetTranscriptionResultDetailUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => DeleteTranscriptionResultUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SetPrimaryTranscriptionResultUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => UpdateWordTextUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => UpdateWordSpeakerUseCase(repository: sl()),
  );
 
  // Repository
  sl.registerLazySingleton<TranscriptDetailRepository>(
    () => TranscriptDetailRepositoryImpl(remoteDataSource: sl()),
  );
 
  // Data sources
  sl.registerLazySingleton<TranscriptDetailRemoteDataSource>(
    () => TranscriptDetailRemoteDataSourceImpl(dioClient: sl()),
  );
}

Future<void> _export() async {
  // Cubit
  sl.registerFactory<ExportCubit>(
    () => ExportCubit(exportTranscriptUseCase: sl()),
  );

  // Use-case
  sl.registerLazySingleton(
    () => ExportTranscriptUseCase(repository: sl()),
  );
}

Future<void> _reTranscribe() async {
  // Cubit
  sl.registerFactory<ReTranscribeCubit>(
    () => ReTranscribeCubit(
      transcribeFileUseCase: sl(),
      getTranscriptionStatusUseCase: sl(),
    ),
  );

  // Use-cases
  sl.registerLazySingleton(
    () => TranscribeFileUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetTranscriptionStatusUseCase(repository: sl()),
  );
}

Future<void> _quota() async {
  // Cubit
  sl.registerFactory<QuotaCubit>(() => QuotaCubit(quotaUseCase: sl()));

  // Use-case
  sl.registerLazySingleton(() => QuotaUseCase(quotaRepository: sl()));

  // Repository
  sl.registerLazySingleton<QuotaRepository>(
      () => QuotaRepositoryImpl(quotaRemoteServices: sl()));

  // Data sources
  sl.registerLazySingleton(() => QuotaRemoteServices());
}

Future<void> _folder() async {
  // Cubit
  sl.registerFactory<FolderCubit>(() => FolderCubit(folderUseCase: sl()));

  // Use-case
  sl.registerLazySingleton(() => FolderUseCase(folderRepository: sl()));

  // Repository
  sl.registerLazySingleton<FolderRepository>(
      () => FolderRepositoryImpl(folderRemoteServices: sl()));

  // Data sources
  sl.registerLazySingleton(() => FolderRemoteServices());
}

Future<void> _upload() async {
  // Cubit
  sl.registerFactory<UploadCubit>(() => UploadCubit(uploadUseCase: sl()));

  // Use-case
  sl.registerLazySingleton(() => UploadUseCase(uploadRepository: sl()));

  // Repository
  sl.registerLazySingleton<UploadRepository>(
      () => UploadRepositoryImpl(uploadRemoteServices: sl()));

  // Data sources
  sl.registerLazySingleton(() => UploadRemoteServices());
}
